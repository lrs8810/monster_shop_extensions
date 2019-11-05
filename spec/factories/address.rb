FactoryBot.define do
  factory :address do
    sequence(:address) {|i| "123#{i} Main Street" }
    sequence(:city) {|i| "Denver#{i}" }
    sequence(:state) {|i| "CO#{i}" }
    sequence(:zip) {|i| "8021#{i}" }
  end
end
