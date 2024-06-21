# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    sequence(:name) { |n| "Call of Testing #{n}" }
  end
end
