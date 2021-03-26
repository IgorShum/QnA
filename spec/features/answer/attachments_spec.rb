require 'rails_helper'

feature 'User can add attachment for answer' do

  context 'Authenticated user' do
    given!(:author) { create(:user) }
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question, user: author) }

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
      within '.links' do
        attach_file('answer[files][]', File.join(Rails.root, '/spec/rails_helper.rb'))
      end
      click_on 'Save'
      expect(page).to have_link 'rails_helper.rb'
    end

    it 'can delete file in edit answer', js: true do
      click_on 'Edit'
      within '.links' do
        attach_file('answer[files][]', File.join(Rails.root, '/spec/rails_helper.rb'))
      end
      click_on 'Save'
      expect(page).to have_link 'rails_helper.rb'
      click_on 'Edit'
      click_on 'Delete rails_helper.rb'
      expect(page).to_not have_content 'rails_helper.rb'
    end

  end
end
