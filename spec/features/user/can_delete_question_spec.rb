require 'rails_helper'

feature 'User can delete questions', %q{
  User can deleted their question/answer
  User cannot delete not their own. Permission denied
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question1) { create(:question, user: user) }
  given(:question2) { create(:question, user: user2) }
  given(:answer1) { create(:answer, question: question1, user: user) }
  given(:answer2) { create(:answer, question: question1, user: user2) }
  given(:answer3) { create(:answer, question: question2, user: user2) }

  background do
    user
    user2
    question1
    question2
    answer1
    answer2
    answer3
  end

  scenario 'user can delete their question' do
    sign_in(user)
    visit questions_path
    page.driver.delete(question_path(question1))
    visit questions_path
    expect(page).to_not have_content question1.id
  end

  scenario 'user cannot delete not their own question' do
    sign_in(user)
    visit question_path(question2)
    expect(page).to_not have_content 'Delete Question'
  end

  scenario 'user cannot delete question, use post request' do
    sign_in(user)
    page.driver.delete(question_path(question2))
    visit question_path(question2)
    expect(page).to have_content 'Permission denied.'
  end
end
