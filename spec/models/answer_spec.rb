require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe 'association' do
    it { should belong_to(:question) }
    it { should have_many(:links).dependent(:destroy) }
  end

  describe 'validation' do
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(6) }
    it { should validate_length_of(:body).is_at_most(1200) }
  end

  it { should accept_nested_attributes_for :links }

  describe 'methods' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:best_answer) { create(:answer, best: true, question: question) }

    it 'mark_as_best changes answer as best' do
      expect(answer.best).to eq false
      answer.mark_as_best
      expect(answer.best).to eq true
    end

    it 'mark_as_best modifies the previous best answer ' do
      expect(best_answer.best).to eq true
      answer.mark_as_best
      best_answer.reload
      expect(best_answer.best).to eq false
    end

  end
end
