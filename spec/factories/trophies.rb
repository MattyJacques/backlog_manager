# frozen_string_literal: true

FactoryBot.define do
  factory :trophy do
    name { 'Shiny Trophy' }
    detail { 'Kill 20 noobs' }
    icon_url { 'trophyicons.com/image' }
    rank { Trophy.ranks[:bronze] }

    sequence(:psn_id) { |n| n }
  end
end
