# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :password_digest

  validates_inclusion_of :enabled?, in: [true, false]

  has_many :orders
  has_many :addresses
  belongs_to :merchant, optional: true

  enum role: %w[default merchant_employee merchant_admin site_admin]
end
