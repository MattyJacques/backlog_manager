# frozen_string_literal: true

FactoryBot.define do
  factory :trophy_list do
    service { 'trophy' }
    icon_url { 'trophyicons.com' }

    sequence(:comm_id) { |n| "NPWR#{format('%05d', n)}_00" }
  end
end
