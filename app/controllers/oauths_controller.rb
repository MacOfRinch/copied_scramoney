class OauthsController < ApplicationController
  require 'securerandom'
  skip_before_action :require_login, raise: false
  skip_before_action :set_family

  def oauth
    provider = auth_params[:provider]
    callback_url = if params[:invitation_code]
                     'https://' + Settings.default_url_options.host + "/oauth/callback?provider=#{provider}&invitation_code=#{params[:invitation_code]}"
                   else
                     Settings.sorcery[:line_callback_url]
                   end
    login_at(provider, callback_url:)
    return unless params[:invitation_code]

    session[:invitation_code] = params[:invitation_code]
  end

  def callback
    invitation_code = session.delete(:invitation_code)
    provider = auth_params[:provider]
    if (@user = login_from(provider, params[:remember_me]))
      redirect_back_or_to family_path(@user.family), success: "#{provider.titleize.upcase}でログインしました"
    else
      @user = create_from(provider)
      @user.email ||= fake_email
      @user.password ||= SecureRandom.urlsafe_base64
      @user.provider ||= provider
      @family = Family.find_by(id: invitation_code)
      if @family
        @user.family = @family
        @user.line_flag = true
        @user.save!
        reset_session
        auto_login(@user)
        redirect_to family_path(@family), success: "#{provider.titleize.upcase}で#{@family.family_name}家に招待されました"
      else
        @family = Family.create(family_name: 'Default_family_name', budget: 50_000)
        @user.family = @family
        @user.line_flag = true
        @user.save!
        reset_session
        auto_login(@user)
        redirect_to edit_family_path(@family), success: "#{provider.titleize.upcase}で認証しました。次に家族情報を入力してください。"
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :error, :state)
  end

  def fake_email
    fake_email = "#{SecureRandom.urlsafe_base64}@example.com"
    fake_email = "#{SecureRandom.urlsafe_base64}@example.com" while User.find_by(email: fake_email).present?
    fake_email
  end
end
