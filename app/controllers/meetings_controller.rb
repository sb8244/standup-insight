class MeetingsController < ApplicationController
  def show
    @view = ShowViewObject.new(current_user, params[:id], params: params)
    return redirect_to url_for(order: @view.meeting_order.join(","), cur: @view.current_order) if !params[:cur]
  end

  def prep
    @view = ShowViewObject.new(current_user, params[:id], params: params)
  end

  def destroy
    StandupMailer.report(standup, from: current_user.email).deliver_now
    redirect_to group_path(params[:id])
  end

  private

  def standup
    current_user.groups.find(params[:id]).todays_standup
  end

  class ShowViewObject
    attr_reader :user, :group, :params

    def initialize(user, id, params:)
      @user = user
      @group = user.groups.find(id)
      @params = params
    end

    def stand_up
      @stand_up ||= group.todays_standup.for_user(whos_up)
    end

    def started_at
      params[:start]
    end

    def meeting_order
      @meeting_order ||= params.fetch(:order) do
        group.users.pluck(:id).shuffle.join(",")
      end.split(",")
    end

    def whos_up
      @whos_up ||= group.users.find(current_order)
    end

    def whos_up_submitted?
      stand_up.completed?
    end

    def current_order
      @current_order ||= params.fetch(:cur) do
        meeting_order.first
      end
    end

    def next_order
      @next_order ||= begin
        next_index = meeting_order.index(current_order) + 1
        meeting_order[next_index] || :done
      end
    end
  end
end
