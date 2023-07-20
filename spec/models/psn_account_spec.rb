# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSNAccount do
  subject(:account) { described_class.new(psn_id: 'Hakoom') }

  it { is_expected.to have_many(:account_trophy_lists).dependent(:destroy) }
  it { is_expected.to have_many(:trophy_lists).through(:account_trophy_lists) }

  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:psn_id) }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:psn_id).case_insensitive }
  end
end
