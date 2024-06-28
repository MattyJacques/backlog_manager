# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Release do
  subject(:release) { build(:release) }

  it { is_expected.to belong_to(:game) }
  it { is_expected.to belong_to(:platform) }

  it do
    expect(release).to define_enum_for(:region).with_values(
      { europe: 1, north_america: 2, australia: 3, new_zealand: 4, japan: 5, china: 6, asia: 7, worldwide: 8, korea: 9,
        brazil: 10 }
    ).with_prefix
  end

  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:igdb_id) }
  end

  context 'when validating numericality' do
    it { is_expected.to validate_numericality_of(:igdb_id) }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:igdb_id) }
  end
end
