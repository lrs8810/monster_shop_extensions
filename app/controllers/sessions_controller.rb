# frozen_string_literal: true

class SessionsController < ApplicationController
  def login
    if current_user
      flash[:error] = 'You are already logged in!'
      redirect_login
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      user.enabled? ? user_login_redirect(user) : user_disabled_render
    else
      user_error_render
    end
  end

  def logout
    reset_session
    flash[:success] = 'You have successfully logged out!'
    redirect_to welcome_path
  end

  private

  def redirect_login
    if merchant_employee? || merchant_admin?
      redirect_to merchant_dashboard_path
    elsif site_admin?
      redirect_to admin_path
    else
      redirect_to profile_path
    end
  end

  def user_login_redirect(user)
    session[:user_id] = user.id
    flash[:success] = "Welcome back, #{user.name}!"
    redirect_login
  end

  def user_error_render
    flash.now[:error] = 'The email and password you entered did not match our records. Please double-check and try again.'
    render :login
  end

  def user_disabled_render
    flash.now[:error] = "Your user account is disabled!"
    render :login
  end
end
