# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::UpdatePSNAccountJob do
  describe '#perform' do
    let(:account) { build(:psn_account) }
    let(:account_id) { '123abc' }

    context 'when the PSN account does not already exist' do
      let(:psn_response) do
        {
          'onlineId' => account.psn_id,
          'accountId' => account_id,
          'npId' => 'SGFrb29tQGEyLnVz',
          'avatarUrls' => [
            { 'size' => 'l', 'avatarUrl' => 'http://static-resource.np.community.playstation.net/avatar/WWS_A/UP90001010001l.png' }
          ],
          'plus' => 1,
          'aboutMe' => '',
          'languagesUsed' => %w[en en-GB],
          'trophySummary' => {
            'level' => 999,
            'progress' => 0,
            'earnedTrophies' => { 'platinum' => 7293, 'gold' => 54_827, 'silver' => 49_414, 'bronze' => 94_862 }
          },
          'isOfficiallyVerified' => false,
          'personalDetailSharing' => 'no',
          'personalDetailSharingRequestMessageFlag' => false,
          'friendRelation' => 'no',
          'requestMessageFlag' => false,
          'blocking' => false,
          'following' => false
        }
      end
      let(:trophy_lists) { create_list(:trophy_list, 2) }

      before do
        allow(PSNAccount).to receive(:find).and_return(account)
        allow(PSN::Client::User).to receive(:get_profile_from_username).with(account.psn_id).and_return(psn_response)
        allow(PSN::Services::ImportAccountDefinedTrophies).to receive(:import).with(account.account_id)
                                                                              .and_return(trophy_lists)
      end

      it 'imports the account, defined trophies and earned trophies' do
        expect(PSN::Client::User).to receive(:get_profile_from_username)
        expect(account).to receive(:update!).with(psn_id: account.psn_id,
                                                  account_id:,
                                                  avatar: anything,
                                                  plus: 1,
                                                  about_me: '')
        expect(PSN::Services::ImportAccountDefinedTrophies).to receive(:import).with(account.account_id)
        expect(PSN::Services::UpdateAccountEarnedTrophies).to receive(:update).with(account.account_id)
        expect(PSN::ScrapeProfileJob).to receive(:perform_now).with(account.psn_id, trophy_lists)

        described_class.perform_now(account.psn_id, should_scrape: true)
      end
    end
  end
end
