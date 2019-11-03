# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  before_action :require_site_admin

  def require_site_admin
    render_404 unless site_admin?
  end
end
