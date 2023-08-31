# frozen_string_literal: true

FactoryBot.define do
  factory :psn_account do
    sequence(:psn_id) { |n| "PSN_Player_#{n}" }

    trait :account_id do
      account_id { '6796840136244039860' }
    end
  end
end
