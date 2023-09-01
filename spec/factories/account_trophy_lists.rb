# frozen_string_literal: true

FactoryBot.define do
  factory :account_trophy_list do
    psn_account { association(:psn_account) }
    trophy_list { association(:trophy_list) }
  end
end
