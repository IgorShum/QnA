require 'rails_helper'

feature 'User can delete answer', %q{
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

  scenario 'user can delete their answer' do
    sign_in(user)
    visit question_path(question1)
    expect(page).to have_content 'AnswerBody'
    click_on 'Delete'
    expect(page).to have_content 'Answer deleted.'
  end

  scenario 'user cannot delete not their own answer' do
    sign_in(user)
    visit question_path(question2)
    expect(page).to have_content answer3.body
    expect(page).to_not have_content 'Delete'
  end

  scenario 'user cannot delete answer, use post request' do
      sign_in(user)
      page.driver.delete(answer_path(answer2))
      visit question_path(question1)
      expect(page).to have_content 'Permission denied.'
  end
end

