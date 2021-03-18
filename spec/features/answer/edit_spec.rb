require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:not_author_question) { create(:question, user: second_user) }
  given!(:not_author_answer) {
    create(:answer, body: 'Second user answer',
                                      question: not_author_question, user: second_user) }


  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "see link 'Edit'" do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'edits his answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Body', with: 'test'
        click_on 'Save'
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content 'Body is too short (minimum is 6 characters)'
    end

    scenario 'not see links for edit other users answer', js: true do
      visit question_path(not_author_question)
      within '.answers' do
        expect(page).to have_content 'Second user answer'
        expect(page).to_not have_link 'Edit'
      end
    end
  end

end
