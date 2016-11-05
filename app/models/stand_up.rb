class StandUp < ApplicationRecord
  belongs_to :group

  has_many :answers

  def completed?(user)
    answers.where(user: user).exists?
  end
end
