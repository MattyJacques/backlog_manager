# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSNAccount do
  subject(:account) do
    described_class.new(psn_id: 'Hakoom')
  end

  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:psn_id) }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:psn_id).case_insensitive }
  end
end
