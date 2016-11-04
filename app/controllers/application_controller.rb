class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  def home
    render text: "home sweet home"
  end
end
