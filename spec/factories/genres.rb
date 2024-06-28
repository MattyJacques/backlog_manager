# frozen_string_literal: true

FactoryBot.define do
  factory :genre do
    name { 'Real Time Strategy (RTS)' }
    slug { 'real-time-strategy-rts' }
    igdb_id { 11 }
  end
end
