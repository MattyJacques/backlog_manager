# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSNAccountsHelper do
  let(:account) { build(:psn_account, account_trophy_lists: [account_list]) }
  let(:account_list) { build(:account_trophy_list, trophy_list:) }
  let(:trophy_list) { build(:trophy_list, releases: [release], platforms: [platform]) }
  let(:platform) { build(:platform) }
  let(:release) { build(:release, platform:) }
  let(:earned_trophies) { instance_double(ActiveRecord::Relation, count: 1) }
  let(:earned_trophy) { instance_double(EarnedTrophy, psn_account: account, trophy_list:, trophy:) }
  let(:trophy) do
    instance_double(Trophy,
                    psn_id: 0,
                    name: 'So Shiny',
                    detail: 'Earn it',
                    icon_url: 'image.com/trophy',
                    rank: 0,
                    trophy_list:,
                    bronze?: true,
                    silver?: true,
                    gold?: true,
                    platinum?: true)
  end

  before do
    allow(earned_trophies).to receive(:preload).with(:trophy).and_return([earned_trophy])
    allow(account).to receive(:earned_trophies).and_return(earned_trophies)
  end

  describe '.get_account_data' do
    let(:expected_result) do
      {
        id: account.id,
        psn_id: account.psn_id,
        game_count: 1,
        platforms: platform.abbreviation,
        trophy_count: 1,
        bronze_count: 1,
        silver_count: 1,
        gold_count: 1,
        platinum_count: 1
      }
    end

    before do
      allow(account.account_trophy_lists).to receive(:preload).and_return(account.account_trophy_lists)
      allow(account.account_trophy_lists).to receive(:count).and_return(1)
    end

    it 'retrurns a hash containing account data' do
      expect(helper.get_account_data(account)).to eql(expected_result)
    end
  end

  describe '.get_trophy_list_data' do
    let(:expected_result) do
      {
        id: trophy_list.id,
        name: trophy_list.name,
        detail: trophy_list.detail,
        comm_id: trophy_list.comm_id,
        progress: '1/1',
        trophy_count: 1,
        bronze_count: 1,
        silver_count: 1,
        gold_count: 1,
        platinum_count: 1
      }
    end

    before do
      allow(trophy_list).to receive(:trophies).and_return([trophy])
    end

    it 'retrurns a hash containing trophy list data' do
      expect(helper.get_trophy_list_data(account_list, earned_trophies)).to eql(expected_result)
    end
  end
end
