# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSNAccountsHelper do
  let(:account) do
    instance_double(PSNAccount,
                    id: 700,
                    psn_id: 'Hakoom',
                    plus: false,
                    account_trophy_lists:)
  end
  let(:account_trophy_lists) { instance_double(ActiveRecord::Relation, count: 1) }
  let(:trophy_list) do
    instance_double(TrophyList,
                    id: 800,
                    name: 'Trophy Clicker',
                    detail: 'Click for instant Platinum!',
                    comm_id: 'NPWR12345_00',
                    service: 'trophy2',
                    icon_url: 'trophyicons.com',
                    platforms: [platform])
  end
  let(:account_list) { instance_double(AccountTrophyList, trophy_list:) }
  let(:platform) { instance_double(Platform, name: 'Game Player', abbreviation: 'GP') }
  let(:release) { instance_double(Release, game:, platform:) }
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
      allow(account_trophy_lists).to receive(:preload).with(trophy_list: :platforms).and_return([account_list])
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
