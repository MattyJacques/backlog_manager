# frozen_string_literal: true

FactoryBot.define do
  factory :trophy_list do
    transient do
      trophy_count { 0 }
    end

    sequence(:comm_id) { |n| "NPWR#{format('%05d', n)}_00" }
    service { 'trophy' }
    icon_url { 'https://image.api.playstation.com/trophy/np/NPWR06221_00_00943B71B23B3A5D98EB6CA419684E0F0A07FA8707/A3E52C438318CCEC6346EB2A31DBF31164A95A25.PNG' }

    trophies do
      Array.new(trophy_count) { association(:trophy, trophy_list: instance) }
    end
  end
end
