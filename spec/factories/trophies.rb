# frozen_string_literal: true

FactoryBot.define do
  factory :trophy do
    name { 'Shiny Trophy' }
    detail { 'Kill 20 noobs' }
    icon_url { 'trophyicons.com/image' }
    rank { Trophy.ranks[:bronze] }

    trophy_list { association(:trophy_list) }

    sequence(:psn_id) { |n| "NPWR#{format('%05d', n)}_00" }
  end
end
