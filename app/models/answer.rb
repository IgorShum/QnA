class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true
  validates :body, length: { minimum: 6, maximum: 1200 }
end
