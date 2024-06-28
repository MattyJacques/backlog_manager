# frozen_string_literal: true

FactoryBot.define do
  factory :platform do
    sequence(:name) { |n| "GamePlayer #{n}" }
    sequence(:abbreviation) { |n| "GP #{n}" }
    sequence(:igdb_id) { |n| n }

    factory :platform_with_family do
      platform_family { association(:platform_family) }
    end
  end
end
