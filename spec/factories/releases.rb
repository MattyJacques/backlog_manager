# frozen_string_literal: true

FactoryBot.define do
  factory :release do
    game { association(:game) }
    platform { association(:platform) }
    sequence(:igdb_id) { |n| n }
  end
end
