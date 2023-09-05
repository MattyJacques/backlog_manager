# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EarnedTrophy do
  it { is_expected.to belong_to(:account_trophy_list) }
  it { is_expected.to have_one(:psn_account).through(:account_trophy_list) }
  it { is_expected.to have_one(:trophy_list).through(:account_trophy_list) }
end
