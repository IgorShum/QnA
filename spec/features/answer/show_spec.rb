require 'rails_helper'

feature 'User can view the list of answers' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers){ create_list(:answer, 2, question: question) }

  context 'Authenticate User' do
    background do
      sign_in(user)
    end

    scenario 'views answers list' do
      visit question_path(question)
      expect(page).to have_content question.answers.first.body
      expect(page).to have_content question.answers.last.body
    end
  end

  scenario 'Nonauthenticated user views answers list' do
    visit question_path(question)
    expect(page).to have_content question.answers.first.body
    expect(page).to have_content question.answers.last.body
  end
end
