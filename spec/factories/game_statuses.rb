# frozen_string_literal: true

FactoryBot.define do
  factory :game_status do
    game {  association(:game) }
    status { GameStatus.statuses[:wishlist] }
  end
end
