class Address < ApplicationRecord

  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_length_of :zip, is: 5
  validates_numericality_of :zip

  belongs_to :user

  enum nickname: %w[Home Work Billing Shipping]
end
