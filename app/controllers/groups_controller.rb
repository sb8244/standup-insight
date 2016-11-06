class GroupsController < ApplicationController
  def index
    @view = IndexViewObject.new(current_user)
  end

  def show
    @submit_standup_view = DashboardViewObject.new(current_user, params: params)
  end

  private

  class IndexViewObject
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def groups
      @groups ||= user.groups.order(id: :desc)
    end

    def today_submitted(group)
      group.todays_standup.for_user(user).completed?
    end

    def completion_percentage(group)
      stand_up = group.todays_standup
      (stand_up.users_answered.fdiv(group.users.count) * 100.0).to_i
    end
  end

  class DashboardViewObject
    attr_reader :user, :params

    def initialize(user, params:)
      @user = user
      @params = params
    end

    def today
      @today ||= Time.now.in_time_zone("US/Eastern").to_date
    end

    def group
      @group ||= user.groups.find(params[:id])
    end

    def question_set
      group.question_set
    end

    def stand_up_type
      params.fetch(:when, "today")
    end

    def stand_up
      method = {
        "today" => :todays_standup,
        "tomorrow" => :tomorrows_standup
      }[stand_up_type] || :todays_standup

      @group.send(method).for_user(user)
    end

    def submitted_count
      @submitted_count ||= stand_up.users_answered
    end

    def group_user_count
      @group_user_count ||= @group.users.count
    end
  end
end
