# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }
    user

    trait :with_files do
      files { Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    end

  end

  factory :invalid_question, class: Question do
    title { nil }
    body { nil }
  end
end
