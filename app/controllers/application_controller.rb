class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  include UsersHelper

  add_flash_types :success, :info, :warning, :danger
  before_action :require_login
  before_action :set_family
  after_action :set_csrf_token_header

  def set_family
    @family = current_user.family
  end

  def set_csrf_token_header
    response.set_header('X-CSRF-Token', form_authenticity_token)
  end
end
