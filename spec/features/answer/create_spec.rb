require 'rails_helper'

feature 'User can write answer on question page' do
  given(:question) { create(:question) }
  given(:questions) { create_list(:question, 2) }
  context 'Authenticated user action on page' do
    given(:user) { create(:user) }
    background do
      sign_in(user)
      question
    end
    scenario 'Authenticated user' do
      visit questions_path
      expect(page).to have_content question.title
      click_on 'MyString'
      expect(page).to have_content question.body
      click_on 'Create Answer'
      fill_in 'Body', with: 'TestText'
      click_on 'Create Answer'
      expect(page).to have_content 'TestText'
    end

    scenario 'Authenticated user write answer in inline form' do
      visit question_path(question)
      expect(page).to have_content 'Body'
      fill_in 'Body', with: 'BodTestText'
      click_on 'Create Answer'
      expect(page).to have_content 'BodTestText'
    end
  end

  scenario 'Nonauthenticated user tries to write answer' do
    question
    visit questions_path
    expect(page).to have_content question.title
    click_on 'MyString'
    fill_in 'Body', with: 'MyString'
    click_on 'Create Answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Nonauthenticated user tries write answer in inline form' do
    question
    visit question_path(question)
    expect(page).to have_content 'Body'
    fill_in 'Body', with: 'BodTestText'
    click_on 'Create Answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
