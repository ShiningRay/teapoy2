FactoryGirl.define do
  factory :user_token do |f|
    provider 'sina'
    user
    uid { Forgery(:basic).text }
    expires_at { 1.week.from_now }
    access_token {Forgery('basic').encrypt}
    secret { Forgery('basic').encrypt }
  end
end
