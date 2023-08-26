# frozen_string_literal: true

FactoryBot.define do
  factory :platform_family do
    name { 'GamePlayers' }

    sequence(:igdb_id) { |n| n }
  end
end
