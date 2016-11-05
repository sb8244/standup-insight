class GroupsController < ApplicationController
  def index
    @groups = current_user.groups.order(id: :desc)
  end

  def show
    @group = current_user.groups.find(params[:id])
  end
end
