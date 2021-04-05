require 'rails_helper'

feature 'User can add links to answer', %q{
 In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:gist_url) { 'https://gist.github.com/IgorShum/c37ad9541ff33e9fb863292b3a01a1ac' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'TestTextBody'
    first_nested = first('.nested-fields')
    within first_nested do
      fill_in 'Link name', with: 'MyGist'
      fill_in 'URL', with: gist_url
    end
    click_on 'Create Answer'
    within '.answers' do
      expect(page).to have_link 'MyGist', href: gist_url
    end
  end
end
