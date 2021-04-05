class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :user

  has_many_attached :files
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :title, length: { minimum: 6, maximum: 120 }
  validates :body, length: { minimum: 6, maximum: 240 }

  def answers_order_by_best
    answers.sort_by_best
  end
end
