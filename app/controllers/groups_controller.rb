class GroupsController < ApplicationController
  def index
    @groups = current_user.groups.order(id: :desc)
  end

  def show
    @submit_standup_view = DashboardViewObject.new(current_user, params: params)
  end

  private

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
      @submitted_count ||= stand_up.answers.count("DISTINCT user_id")
    end

    def group_user_count
      @group_user_count ||= @group.users.count
    end
  end
end
