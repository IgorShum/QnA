# frozen_string_literal: true

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :answer do
    body { 'AnswerBody' }
    question
    user
    best { false }
    files { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
  end

  factory 'invalid_answer', class: Answer do
    body { nil }
  end
end
