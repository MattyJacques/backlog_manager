# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrophyList do
  subject(:trophy_list) do
    described_class.new(comm_id: 'NPWR12345_00',
                        service: 'trophy2',
                        icon_url: 'trophyicons.com')
  end

  it { is_expected.to have_many(:releases).dependent(:nullify) }
  it { is_expected.to have_many(:trophies).dependent(:destroy) }
  it { is_expected.to have_many(:account_trophy_lists).dependent(:destroy) }
  it { is_expected.to have_many(:psn_accounts).through(:account_trophy_lists) }

  it do
    expect(trophy_list).to define_enum_for(:region).with_values(
      { europe: 0, north_america: 1, germany: 2, asia: 3, china: 4, japan: 5, original: 6 }
    )
  end

  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:comm_id) }
    it { is_expected.to validate_presence_of(:service) }
    it { is_expected.to validate_presence_of(:icon_url) }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:comm_id).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:title_id).case_insensitive }
  end

  context 'when validating format' do
    it { is_expected.to allow_values('NPWR00160_00', 'NPWR22792_00').for(:comm_id) }
    it { is_expected.not_to allow_values('7', '00160_00').for(:comm_id) }
  end
end
