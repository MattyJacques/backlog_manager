# frozen_string_literal: true

FactoryBot.define do
  factory :genre do
    sequence(:name) { |n| "Genre #{n}" }
    sequence(:slug) { |n| " genre-#{n}" }
    sequence(:igdb_id) { |n| n }
  end
end
