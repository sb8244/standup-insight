class StandupMailer < ApplicationMailer
  def report(standup, from:)
    emails = standup.group.users.gets_email.pluck(:email)

    @view = ViewObject.new(standup)

    mail(from: from, cc: emails, subject: "Standup Summary - #{standup.date_of_standup}")
  end

  class ViewObject
    attr_reader :standup

    def initialize(standup)
      @standup = standup
    end

    def users
      @standup.group.users.sort_by(&:display_name)
    end

    def answers_by_user
      @answers_by_user ||= begin
        Hash.new([]).merge(standup.answers.order(:question_id).group_by(&:user))
      end
    end
  end
end
