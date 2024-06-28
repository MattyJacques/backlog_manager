# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlatformFamily do
  subject(:family) { build(:platform_family) }

  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:igdb_id) }
  end

  context 'when validating numericality' do
    it { is_expected.to validate_numericality_of(:igdb_id).only_integer }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:igdb_id) }
  end
end
