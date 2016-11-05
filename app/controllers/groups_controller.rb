class GroupsController < ApplicationController
  def index
    @groups = current_user.groups.order(id: :desc)
  end

  def show
    @group = current_user.groups.find(params[:id])
    @question_set = @group.question_set
    @stand_up = stand_up
    @stand_up_type = stand_up_type
  end

  private

  def stand_up_type
    params.fetch(:when, "today")
  end

  def stand_up
    method = {
      "today" => :todays_standup,
      "tomorrow" => :tomorrows_standup
    }[stand_up_type] || :todays_standup

    @group.send(method).for_user(current_user)
  end
end
