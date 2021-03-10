require 'rails_helper'

feature 'User can view the list of questions' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answers){ create_list(:answer, 2, question: question) }
  given(:questions) { create_list(:question, 2) }

  context 'Authenticate User' do
    background do
      sign_in(user)
    end
    scenario 'views question list' do
      visit questions_path
      expect(page).to have_content 'Questions list'
    end

    scenario 'views question and answers' do
      question
      answers
      visit question_path(question)
      expect(page).to have_content question.answers.first.body
      expect(page).to have_content question.answers.last.body
    end
  end

  scenario 'Nonauthenticated user' do
    visit questions_path
    expect(page).to have_content 'Questions list'
  end
end
