# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { 'SuperSecurePassword' }

    sequence(:username) { |n| "Testing Attention Please #{n}" }
    sequence(:email) { |n| "testing#{n}@yopmail.com" }
  end
end
