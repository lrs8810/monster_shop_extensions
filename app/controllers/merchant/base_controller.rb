# frozen_string_literal: true

class Merchant::BaseController < ApplicationController
  before_action :require_merchant

  def require_merchant
    render_404 unless merchant_admin? || merchant_employee?
  end
end
