require 'rails_helper'

feature 'User can write answer on question page' do
  given!(:question) { create(:question) }
  given!(:questions) { create_list(:question, 2) }

  context 'Action on page' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_content question.body
    end

    scenario 'write answer with valid params in inline form', js: true do
      fill_in 'Body', with: 'BodTestText'
      click_on 'Create Answer'
      expect(page).to have_content 'BodTestText'
    end

    scenario 'write answer with invalid params in inline form', js: true do
      fill_in 'Body', with: 'body'
      click_on 'Create Answer'
      expect(page).to have_content 'Body is too short (minimum is 6 characters)'
    end

    scenario 'create answer with errors', js: true do
      click_on 'Create Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Nonauthenticated user tries write answer in inline form' do
    visit question_path(question)
    fill_in 'Body', with: 'BodTestText'
    click_on 'Create Answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
