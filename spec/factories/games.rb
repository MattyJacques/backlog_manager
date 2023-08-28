# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    sequence(:id) { |n| n }
    sequence(:name) { |n| "Call of Dooty #{n}" }

    factory :game_with_platform do
      platforms { [association(:platform)] }
    end
  end
end
