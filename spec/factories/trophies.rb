# frozen_string_literal: true

FactoryBot.define do
  factory :trophy do
    name { 'Shiny Trophy' }
    detail { 'Kill 20 noobs' }
    icon_url { 'https://image.api.playstation.com/trophy/np/NPWR06221_00_00943B71B23B3A5D98EB6CA419684E0F0A07FA8707/A9010E55676D17637F170F8601B2DFFE0984EB68.PNG' }
    rank { Trophy.ranks[:bronze] }

    sequence(:psn_id) { |n| n }

    factory :trophy_with_list do
      trophy_list { association(:trophy_list, trophies: [instance]) }
    end
  end
end
