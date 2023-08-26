# frozen_string_literal: true

FactoryBot.define do
  factory :psn_account do
    sequence(:psn_id) { |n| "PSN Player #{n}" }
  end
end
