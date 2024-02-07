class HelloController < ApplicationController
  skip_before_action :require_login
  skip_before_action :set_family

  def index
  end

  def create
    redirect_to "https://access.line.me/dialog/bot/accountLink", allow_other_host: true
  end
end
