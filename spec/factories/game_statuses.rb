# frozen_string_literal: true

FactoryBot.define do
  factory :game_status do
    status { :wishlist }

    game { association(:game) }
    user { association(:user) }
  end
end
