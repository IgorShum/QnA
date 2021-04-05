require 'rails_helper'

feature 'User can add attachment for answer' do
  given!(:author) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  context 'Authenticated user' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    it 'can add file in new answer form', js: true do
      fill_in 'Body', with: 'BodyAnswerWithFile'
      attach_file('answer[files][]', File.join(Rails.root, '/spec/rails_helper.rb'))
      click_on 'Create Answer'
      expect(page).to have_link 'rails_helper.rb'
    end

    it 'can add file on edit their answer', js: true do
      expect(page).to_not have_link 'rails_helper.rb'
      click_on 'Edit'
      first_link_block = first('.links')
      within first_link_block do
        attach_file('answer[files][]', File.join(Rails.root, '/spec/rails_helper.rb'))
      end
      click_on 'Save'
      expect(page).to have_link 'rails_helper.rb'
    end

    it 'can delete file in edit answer', js: true do
      click_on 'Edit'
      first_link_block = first('.links')
      within first_link_block do
        attach_file('answer[files][]', File.join(Rails.root, '/spec/rails_helper.rb'))
      end
      click_on 'Save'
      expect(page).to have_link 'rails_helper.rb'
      click_on 'Edit'
      click_on 'Delete rails_helper.rb'
      click_on 'Save'
      expect(page).to_not have_content 'rails_helper.rb'
    end
  end

  context 'Non-authenticate user', js: true do
    scenario 'not view links for attachments', js: true do
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_selector('input', class: 'form-control-file', id: 'answer_files')
      end
    end
  end
end
