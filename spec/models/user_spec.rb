require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'User author_of created question' do
    user = FactoryBot.create(:user)
    question = FactoryBot.create(:question, user: user)
    expect(user.author_of?(question)).to eq true
  end

  it 'User not author not their own question' do
    user = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    question = FactoryBot.create(:question, user: user2)
    expect(user.author_of?(question)).to_not eq true
  end

  it 'User author_of created answer' do
    user = FactoryBot.create(:user)
    answer = FactoryBot.create(:answer, user: user)
    expect(user.author_of?(answer)).to eq true
  end

  it 'User not author not their own answer' do
    user = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    answer = FactoryBot.create(:answer, user: user2)
    expect(user.author_of?(answer)).to_not eq true
  end
end
