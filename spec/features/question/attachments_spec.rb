require 'rails_helper'

feature 'User can add attachment for question' do
  given!(:author) { create(:user) }
  given!(:question_without_files) { create(:question, user: author) }

  context 'Authenticate user' do
    before do
      sign_in(author)
      visit questions_path
    end

    scenario 'can add attachment to new question', js: true do
      click_on 'Ask question'
      fill_in 'Title', with: 'Question with attachments'
      fill_in 'Body', with: 'I can add attachment'
      attach_file('question[files][]', File.join(Rails.root, '/spec/rails_helper.rb'))
      click_button('Ask')
      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_link('rails_helper.rb')
    end

    scenario 'can add attachment to question from edit form', js: true do
      visit question_path(question_without_files)
      expect(page).to_not have_link('rails_helper.rb')
      click_on 'Edit'
      attach_file('question[files][]', File.join(Rails.root, '/spec/rails_helper.rb'))
      click_button('Save')
      expect(page).to have_link('rails_helper.rb')
    end
  end

  context 'Non-authenticate user', js: true do
    scenario 'not view links for attachments, not their question', js: true do
      visit question_path(question_without_files)
      expect(page).to_not have_selector('input', class: 'form-control-file', id: 'question_files')
    end
  end
end
