# frozen_string_literal: true

FactoryBot.define do
  factory :platform_family do
    sequence(:name) { |n| "GamePlayers #{n}" }
    sequence(:igdb_id) { |n| n }
  end
end
