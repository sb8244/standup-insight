class StandUp < ApplicationRecord
  belongs_to :group

  has_many :answers

  def for_user(user)
    @user = user
    self
  end

  def users_answered
    answers.count("DISTINCT user_id")
  end

  def completed?
    raise ArgumentError.new("User must be set") unless @user.present?
    users_answers.exists?
  end

  def users_answers
    raise ArgumentError.new("User must be set") unless @user.present?
    answers.where(user: @user)
  end
end
