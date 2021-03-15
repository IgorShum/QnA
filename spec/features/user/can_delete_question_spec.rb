require 'rails_helper'

feature 'User can delete questions', %q{
  User can deleted their question
  User does not see links to delete
} do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question1) { create(:question, body: 'TestQuestionOne', user: user) }
  given!(:question2) { create(:question, body: 'TestQuestionTwo', user: user2) }

  context 'Authenticate user' do
    background do
      sign_in(user)
    end

    scenario 'can delete their question' do
      visit questions_path
      expect(page).to have_content question1.body
      click_on 'Delete Question'
      expect(page).to have_content 'Question deleted.'
      expect(page).to_not have_content question1.body
    end

    scenario 'does not see links to delete' do
      visit question_path(question2)
      expect(page).to_not have_content 'Delete Question'
    end
  end

  context 'Nonauthenticated user' do
    scenario 'does not see links to delete in questions list' do
      visit questions_path
      expect(page).to_not have_content 'Delete Question'
    end

    scenario 'does not see links to delete in question page' do
      visit question_path(question1)
      expect(page).to_not have_content 'Delete Question'
    end
  end
end
