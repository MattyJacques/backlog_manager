# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Platform do
  subject(:platform) { build(:platform) }

  it { is_expected.to belong_to(:platform_family).optional(true) }

  describe 'validations' do
    before do
      described_class.skip_callback(:create, :after, :import_igdb_data)
    end

    after do
      described_class.set_callback(:create, :after, :import_igdb_data)
    end

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

  describe '#import_igdb_data' do
    subject(:platform) { described_class.new(igdb_id:) }

    let(:igdb_id) { 7 }

    it 'queues the import platform from IGDB job' do
      platform.run_callbacks(:create)

      expect(IGDB::ImportPlatformJob).to have_been_enqueued.with(igdb_id)
    end
  end
end
