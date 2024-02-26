class HomeController < ApplicationController
  skip_before_action :require_login
  skip_before_action :set_family

  def top
    return unless logged_in?

    family = current_user.family
    redirect_to family_path(family)
  end
end
