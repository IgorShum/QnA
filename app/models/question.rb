class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true
  validates :title, length: { minimum: 6, maximum: 120 }
  validates :body, length: { minimum: 6, maximum: 240 }

  def answers_order_by_best
    answers.sort_by_best
  end
end
