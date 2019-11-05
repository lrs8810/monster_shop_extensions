FactoryBot.define do
  factory :user do
    sequence(:name) {|i| "123#{i} Main Street" }
    sequence(:email) {|i| "Denver#{i}" }
    sequence(:state) {|i| "CO#{i}" }
    sequence(:zip) {|i| "8021#{i}" }
  end
end
