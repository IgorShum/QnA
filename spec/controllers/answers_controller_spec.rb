require 'rails_helper'
require 'support/factory_bot'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:answers) { create_list(:answer, 2, question: question, user: user) }

  describe 'GET #edit' do
    before do
      login(user)
      get :edit, params: { id: answer }
    end

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }
    it 'with valid attributes' do
      expect {
        post :create,
             params: { answer: attributes_for(:answer),
                       question_id: question.id }, format: :js }.to change(question.answers, :count).by(1)
    end

    it 'redirect to show view' do
      post :create, params: { answer: attributes_for(:answer), question_id: answer.question_id }, format: :js
      expect(response).to render_template :create
    end

    it 'with invalid attributes' do
      expect {
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id,
                                user: user }, format: :js }.to_not change(Answer, :count)
    end

    it 're-renders view' do
      post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id }, format: :js
      expect(response).to render_template :create
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'valid attributes' do
      it 'assign the requested answer to @answer' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer), user: user }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        b = 'new text body'
        patch :update, params: { id: answer.id, answer: { body: b } }, format: :js
        answer.reload
        expect(answer.body).to eq b
      end

      it 'redirect to updated answer' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: answer.id, answer: { body: nil } }, format: :js }
      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'AnswerBody'
      end

      it 're-render view edit' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author of answer' do
      before { login(user) }

      it 'delete answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'non author of answer' do
      before { login(user2) }

      it 'tries delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to view after tries delete' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end
  end

  describe 'POST #best' do
    before { login(user) }

    it 'changes answer attributes' do
      expect(answer.best).to eq false
      post :best, params: { id: answer.id, answer: answer }, format: :js
      answer.reload
      expect(answer.best).to eq true
    end

    it 'render update template' do
      post :best, params: { id: answer.id, answer: answer }, format: :js
      expect(response).to render_template :update
    end
  end
end
