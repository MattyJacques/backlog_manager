# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    sequence(:id) { |n| n }
    sequence(:name) { |n| "Call of Dooty #{n}" }

    trait :trophies do
      releases { [association(:release_with_trophies, game: instance)] }
      trophy_lists { releases.map(&:trophy_list) }
    end

    factory :game_with_platform do
      platforms { [association(:platform)] }
    end

    factory :released_game do
      releases { [association(:release)] }
    end
  end
end
