require 'rails_helper'

feature 'User can register' do
  background do
    visit new_user_session_path
    click_on 'Sign up'
    fill_in 'Email', with: 'Testmail@gmail.com'
  end

  scenario 'with invalid short password' do
    fill_in 'Password', with: '12345'
    fill_in 'Password confirmation', with: '12345'
    click_on 'Sign up'
    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
  end

  scenario 'with different pass and confirmation' do
    fill_in 'Password', with: '12345'
    fill_in 'Password confirmation', with: '54321'
    click_on 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'with valid params' do
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
