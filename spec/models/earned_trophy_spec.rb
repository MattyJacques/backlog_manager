# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EarnedTrophy do
  it { is_expected.to belong_to(:psn_account) }
  it { is_expected.to belong_to(:trophy) }
end
