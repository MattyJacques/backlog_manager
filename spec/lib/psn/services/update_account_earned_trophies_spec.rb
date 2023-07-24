# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Services::UpdateAccountEarnedTrophies do
  describe '.update', :vcr do
    let(:account) do
      instance_double(PSNAccount,
                      id: 1,
                      account_id: '6796840136244039860',
                      earned_trophies: instance_double(ActiveRecord::Relation))
    end
    let(:all_titles_response) do
      [
        {
          'npServiceName' => 'trophy',
          'npCommunicationId' => np_comm_id,
          'trophySetVersion' => '01.12',
          'trophyTitleName' => 'SUPER STARDUST™ HD',
          'trophyTitleDetail' => 'SUPER STARDUST™ HD',
          'trophyTitleIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR00117_00_00E2D6C0A2BB7475BC6C26626F04790CDAD0507E33/797A9F853E90AE722EE315B9A8747E0842390FF3.PNG',
          'trophyTitlePlatform' => 'PS3',
          'hasTrophyGroups' => false,
          'definedTrophies' => { 'bronze' => 9, 'silver' => 6, 'gold' => 2, 'platinum' => 0 },
          'progress' => 100,
          'earnedTrophies' => { 'bronze' => 9, 'silver' => 6, 'gold' => 2, 'platinum' => 0 },
          'hiddenFlag' => false,
          'lastUpdatedDateTime' => last_update_timestamp
        }
      ]
    end
    let(:np_comm_id) { 'NPWR00117_00' }
    let(:last_update_timestamp) { DateTime.now.to_s }
    let(:trophy_list) { instance_double(TrophyList, id: 1, trophies: instance_double(ActiveRecord::Relation)) }
    let(:trophy) { instance_double(Trophy) }

    before do
      allow(PSNAccount).to receive(:find_by!).with(account_id: account.account_id).and_return(account)
      allow(PSN::Client::Trophy).to receive(:all_account_titles).and_return(all_titles_response)
      allow(TrophyList).to receive(:find_by!).with(comm_id: np_comm_id).and_return(trophy_list)
      allow(trophy_list.trophies).to receive(:find_by!).and_return(trophy)
    end

    context 'when all trophies are new' do
      before do
        allow(account.earned_trophies).to receive(:exists?).and_return(false)
      end

      it 'creates records for all trophies' do
        expect(AccountTrophyList).to receive(:create!).with(psn_account: account, trophy_list:)
        expect(EarnedTrophy).to receive(:create!).exactly(17).times

        described_class.update(account.account_id)
      end
    end

    context 'when title has not been updated on psn' do
      # instance_double does not seem to work alongside the touch method
      let(:account_trophy_list) { AccountTrophyList.new(updated_at: DateTime.tomorrow) }

      before do
        allow(AccountTrophyList).to receive(:find_by).and_return(account_trophy_list)
      end

      it 'does not import/update any trophies' do
        expect(account_trophy_list).to receive(:touch)
        expect(EarnedTrophy).not_to receive(:create!)
        expect_any_instance_of(EarnedTrophy).not_to receive(:update!)

        described_class.update(account.account_id)
      end
    end

    context 'when a trophy timestamp has been updated to earlier time' do
      # instance_double does not seem to work alongside the touch method
      let(:account_trophy_list) { AccountTrophyList.new(updated_at: DateTime.yesterday) }
      let(:earned_trophy) { instance_double(EarnedTrophy) }

      before do
        allow(AccountTrophyList).to receive(:find_by).and_return(account_trophy_list)
        allow(account.earned_trophies).to receive(:find_by!).and_return(earned_trophy)
        allow(account.earned_trophies).to receive(:exists?).with(trophy:, timestamp: anything).and_return(false)
        allow(account.earned_trophies).to receive(:exists?).with(trophy:).and_return(true)
      end

      it 'updates the trophy timestamp' do
        expect(account_trophy_list).to receive(:touch)
        expect(earned_trophy).to receive(:update!).with(timestamp: anything).exactly(17).times

        described_class.update(account.account_id)
      end
    end
  end
end
