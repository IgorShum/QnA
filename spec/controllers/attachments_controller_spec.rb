require 'rails_helper'
require 'factory_bot'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, :with_files, user: author) }
    let!(:nonauthor) { create(:user) }

    before do
      question.files.attach(
        io: File.open(Rails.root.join('spec/rails_helper.rb')),
        filename: 'rails_helper.rb',
        content_type: 'application/text'
      )
    end

    context 'Author' do
      before { login(author) }

      it 'changed count attachments' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
      end
    end

    context 'Non-Author' do
      before { login(nonauthor) }

      it 'tries delete not their record, not change count' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      end

      it 'return forbidden for delete tries' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to have_http_status :forbidden
      end
    end
  end

end
