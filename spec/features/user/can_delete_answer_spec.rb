require 'rails_helper'

feature 'User can delete answer', %q{
  User can deleted their answer
  User does not see links to delete
} do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question1) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user2) }
  given!(:answer1) { create(:answer, body: 'AnswerBody3', question: question1, user: user) }
  given!(:answer2) { create(:answer, question: question1, user: user2) }
  given!(:answer3) { create(:answer, question: question2, user: user2) }

  context 'Authenticate user' do
    background do
      sign_in(user)
    end

    scenario 'user can delete their answer' do
      visit question_path(question1)
      expect(page).to have_content 'AnswerBody3'
      click_on 'Delete'
      expect(page).to have_content 'Answer deleted.'
      expect(page).to_not have_content 'AnswerBody3'
    end

    scenario 'user does not see links to delete' do
      visit question_path(question2)
      expect(page).to have_content answer3.body
      expect(page).to_not have_content 'Delete'
    end
  end

  context 'Nonauthenticate user' do
    scenario 'not view delete link' do
      visit question_path(question1)
      expect(page).to_not have_content 'Delete'
    end
  end
end
