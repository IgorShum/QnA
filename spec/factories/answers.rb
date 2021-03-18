# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'AnswerBody' }
    question
    user
    best { false }
  end

  factory 'invalid_answer', class: Answer do
    body { nil }
  end
end
