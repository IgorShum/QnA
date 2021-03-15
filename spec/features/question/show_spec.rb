require 'rails_helper'

feature 'User can view the list of questions' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question2) { create(:question) }

  context 'Authenticate User' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'views question list' do
      expect(page).to have_content question.body
      expect(page).to have_content question.body
    end

    scenario 'follow the link and view question' do
      visit question_path(question)
      expect(page).to have_content question.body
    end
  end

  context 'Nonauthenticated user' do
    scenario 'see question list' do
      visit questions_path
      expect(page).to have_content question.body
      expect(page).to have_content question2.body
    end

    scenario 'follow the link and view question' do
      visit question_path(question)
      expect(page).to have_content question.body
    end
  end
end
