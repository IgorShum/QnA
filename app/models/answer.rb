class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  validates :body, length: { minimum: 6, maximum: 1200 }

  scope :sort_by_best, -> { with_attached_files.order(best: :desc) }

  def mark_as_best
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update!(best: true)
    end
  end
end
