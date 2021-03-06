class Group < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :stand_ups
  has_one :slack_integration

  def todays_standup
    @todays_standup ||= find_or_create_standup_for_day!(0)
  end

  def tomorrows_standup
    @tomorrows_standup ||= find_or_create_standup_for_day!(1)
  end

  def question_set
    @question_set ||= QuestionSet.new
  end

  private

  def find_or_create_standup_for_day!(days)
    stand_ups.where(date_of_standup: Time.now.in_time_zone("US/Eastern").to_date + days).first_or_create!
  end
end
