class GroupsController < ApplicationController
  def index
    @groups = current_user.groups.order(id: :desc)
  end
end
