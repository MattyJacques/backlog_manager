# frozen_string_literal: true

FactoryBot.define do
  factory :trophy_list do
    transient do
      trophy_count { 0 }
    end

    service { 'trophy' }
    icon_url { 'trophyicons.com' }

    sequence(:comm_id) { |n| "NPWR#{format('%05d', n)}_00" }

    trophies do
      Array.new(trophy_count) { association(:trophy, trophy_list: instance) }
    end
  end
end
