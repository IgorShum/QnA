require 'rails_helper'

feature 'User can be mark best answer' do
  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:second_question) { create(:question, user: second_user) }
  given!(:answer) { create(:answer, question: question, user: second_user) }
  given(:second_answer) { create(:answer, question: question, user: second_user) }
  given(:best_answer) { create(:answer, body: 'BestAnswer', best: true, user: user, question: question) }
  given!(:not_best_answer) { create(:answer, body: 'NotBestAnswer', user: user, question: second_question) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
    end

    scenario 'Author of question mark best answer', js: true do
      second_answer
      visit question_path(question)
      first_answer = first('.answer')
      expect(first_answer).to_not have_css('.best')
      within first_answer do
        click_on('Best!')
      end
      expect(page).to have_css('.answer.best')
    end

    scenario 'Re-mark best answer should be only one', js: true do
      best_answer
      visit question_path(question)
      not_best_answer = find('.answer', text: 'AnswerBody')
      expect(not_best_answer).to_not have_css('.best')
      within not_best_answer do
        click_on('Best!')
      end
      expect(find('.answer', text: 'BestAnswer')).to_not have_css('.best')
    end

    scenario 'Non-author' do
      visit question_path(second_question)
      expect(page).to_not have_selector(:link_or_button, 'Best!')
    end
  end

  describe 'Non-Authenticated user' do
    scenario 'not see link for choise best answer' do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Best!')
    end
  end
end
