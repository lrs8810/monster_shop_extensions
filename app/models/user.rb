# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :password_digest

  validates_inclusion_of :enabled?, in: [true, false]

  validates_length_of :zip, is: 5
  validates_numericality_of :zip

  has_many :orders
  belongs_to :merchant, optional: true

  enum role: %w[default merchant_employee merchant_admin site_admin]
end
