class StandupMailer < ApplicationMailer
  def report(standup)
    emails = standup.group.users.pluck(:email)
    primary = emails.first

    @view = ViewObject.new(standup)

    mail(from: primary, cc: emails, subject: "Standup Summary - #{standup.date_of_standup}")
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
