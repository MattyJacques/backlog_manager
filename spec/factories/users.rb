# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "Testing Attention Please #{n}" }
    sequence(:email) { |n| "testing#{n}@yopmail.com" }
    password { 'SuperSecurePassword' }

    factory :user_with_psn do
      psn_account { association(:psn_account) }
    end
  end
end
