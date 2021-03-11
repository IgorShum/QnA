require 'rails_helper'
require 'support/factory_bot'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:answers) { create_list(:answer, 2, question: question, user: user) }

  describe 'GET #index' do
    before { login(user) }
    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end

  end

  describe 'GET #show' do
    before { login(user) }
    before { get :show, params: { id: answer.id } }
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns to requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: answer.question_id } }
    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render :new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: answer } }

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
                       question_id: question.id } }.to change(question.answers, :count).by(1)
    end

    it 'redirect to show view' do
      post :create, params: { answer: attributes_for(:answer), question_id: answer.question_id }
      expect(response).to redirect_to question_path(assigns(:question))
    end

    it 'with invalid attributes' do
      expect {
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id,
                                user: user } }.to_not change(Answer, :count)
    end

    it 're-renders view' do
      post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id,
                              user: user }
      expect(response).to redirect_to question
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'valid attributes' do
      it 'assign the requested answer to @answer' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer), user: user}
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        b = 'new text body'
        patch :update, params: { id: answer.id, answer: { body: b } }
        answer.reload
        expect(answer.body).to eq b
      end

      it 'redirect to updated answer' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer.question
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: answer.id, answer: { body: nil } } }
      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'AnswerBody'

      end

      it 're-render view edit' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    before { answer }

    it 'delete answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to root_path
    end
  end
end
