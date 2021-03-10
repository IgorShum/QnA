require 'rails_helper'

feature 'User can write answer on question page' do
  given(:question) { create(:question) }
  given(:questions) { create_list(:question, 2) }
  context 'Authenticated user action' do
    given(:user) { create(:user) }
    scenario 'Authenticated user' do
      sign_in(user)
      question
      visit questions_path
      expect(page).to have_content question.title
      click_on 'MyString'
      expect(page).to have_content 'New Answer'
      click_on 'New Answer'
      fill_in 'Body', with: 'TestText'
      click_on 'Create Answer'
      expect(page).to have_content 'TestText'
    end
  end

  scenario 'Nonauthenticated user tries to write answer' do
    question
    visit questions_path
    expect(page).to have_content question.title
    click_on 'MyString'
    expect(page).to have_content question.body
    expect(page).to have_content 'New Answer'
    click_on 'New Answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end