require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:question2) { create(:question, user: user2) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'User author_of created question' do
    expect(user).to be_author_of(question)
  end

  it 'User not author not their own question' do
    expect(user).to_not be_author_of(question2)
  end
end
