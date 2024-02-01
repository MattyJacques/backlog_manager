# frozen_string_literal: true

FactoryBot.define do
  factory :platform do
    sequence(:name) { |n| "GamePlayer #{n}" }
    sequence(:abbreviation) { |n| "GP #{n}" }

    factory :platform_with_family do
      platform_family { association(:platform_family) }
    end

    factory :ps4 do
      name { 'PlayStation 4' }
      abbreviation { 'PS4' }
      igdb_id { 48 }
    end
  end
end
