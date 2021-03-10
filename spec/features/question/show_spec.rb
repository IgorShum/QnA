require 'rails_helper'

feature 'User can view the list of questions' do

  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 2) }

  scenario 'Authenticated user' do
    sign_in(user)
    visit questions_path
    expect(page).to have_content 'Questions list'
  end

  scenario 'Nonauthenticated user' do
    visit questions_path
    expect(page).to have_content 'Questions list'
  end
end
