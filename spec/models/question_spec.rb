require 'rails_helper'

RSpec.describe Question, type: :model do

  describe 'association' do
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validation' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_length_of(:title).is_at_least(6).is_at_most(120) }
    it { should validate_length_of(:body).is_at_least(6).is_at_most(240) }
  end

  it 'have one attached file' do
    expect(Question.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
