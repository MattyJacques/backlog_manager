# frozen_string_literal: true

FactoryBot.define do
  factory :release do
    game { association(:game) }
    platform { association(:platform) }

    factory :release_with_trophies do
      trophy_list { association(:trophy_list, releases: [instance]) }
    end
  end
end
