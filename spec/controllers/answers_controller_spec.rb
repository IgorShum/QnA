require 'rails_helper'
require 'support/factory_bot'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:answers) { create_list(:answer, 2, question: question) }

  describe 'GET #index' do
    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end

  end

  describe 'GET #show' do
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
    before { get :new, params: { question_id: answer.question_id } }
    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render :new view' do
      expect(response).to render_template :new
    end
  end

end
