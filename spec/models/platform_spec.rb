# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Platform do
  subject(:platform) { build(:platform) }

  it { is_expected.to belong_to(:platform_family).optional(true) }

  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:igdb_id) }
  end

  context 'when validating numericality' do
    it { is_expected.to validate_numericality_of(:igdb_id) }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.allow_nil }
    it { is_expected.to validate_uniqueness_of(:slug).case_insensitive.allow_nil }
    it { is_expected.to validate_uniqueness_of(:igdb_id) }
  end
end
