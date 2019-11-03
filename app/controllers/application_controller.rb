# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user, :merchant_employee?, :merchant_admin?, :site_admin?

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def merchant_employee?
    current_user&.merchant_employee?
  end

  def merchant_admin?
    current_user&.merchant_admin?
  end

  def site_admin?
    current_user&.site_admin?
  end

  def render_404
    render file: '/public/404'
  end
end
