# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    sequence(:name) { |n| "Call of Dooty #{n}" }

    factory :game_with_status do
      game_statuses { [association(:game_status)] }
    end
  end
end
