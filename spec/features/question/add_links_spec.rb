require 'rails_helper'

feature 'User can add links to question', %q{
 In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given!(:user) { create(:user) }
  given!(:gist_url) { 'https://gist.github.com/IgorShum/c37ad9541ff33e9fb863292b3a01a1ac' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'LinksAddText'
    fill_in 'Body', with: 'BodyLinksText'
    fill_in 'Link name', with: 'MyGist'
    fill_in 'Url', with: gist_url
    click_on 'Ask'

    expect(page).to have_link 'MyGist', href: gist_url
  end
end
