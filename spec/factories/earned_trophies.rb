# frozen_string_literal: true

FactoryBot.define do
  factory :earned_trophy do
    psn_account { association(:psn_account) }
    trophy_list { association(:trophy_list) }
    trophy { association(:trophy, trophy_list:) }
  end
end
