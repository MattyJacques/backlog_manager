# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountTrophyList do
  it { is_expected.to belong_to(:psn_account) }
  it { is_expected.to belong_to(:trophy_list) }
  it { is_expected.to have_many(:earned_trophies).dependent(:destroy) }
end
