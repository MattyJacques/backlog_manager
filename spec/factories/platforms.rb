# frozen_string_literal: true

FactoryBot.define do
  factory :platform do
    sequence(:name) { |n| "GamePlayer #{n}" }

    factory :platform_with_family do
      platform_family
    end
  end
end
