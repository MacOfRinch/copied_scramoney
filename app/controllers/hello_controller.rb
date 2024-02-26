class HelloController < ApplicationController
  skip_before_action :require_login
  skip_before_action :set_family

  def index; end

end
