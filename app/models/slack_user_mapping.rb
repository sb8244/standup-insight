class SlackUserMapping < ApplicationRecord
  belongs_to :user
  belongs_to :group

  has_many :slack_answer_sessions

  def active_session
    slack_answer_sessions.find_by(status: ["active"])
  end
end
