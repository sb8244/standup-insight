class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def home
    render text: "home sweet home"
  end
end
