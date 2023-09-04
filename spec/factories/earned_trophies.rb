# frozen_string_literal: true

FactoryBot.define do
  factory :earned_trophy do
    account_trophy_list { association(:account_trophy_list) }
    trophy { association(:trophy) }
  end
end
