# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::UpdatePSNAccountJob do
  describe '#perform' do
    let(:account) { instance_double(PSNAccount, account_id: '123456789') }

    context 'when the PSN account does not already exist' do
      let(:username) { 'Hakoom' }
      let(:psn_response) do
        {
          'onlineId' => username,
          'accountId' => '6796840136244039860',
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

      before do
        allow(PSNAccount).to receive(:create).and_return(account)
        allow(PSN::Client::User).to receive(:get_profile_from_username).with(username).and_return(psn_response)
      end

      it 'imports the account, defined trophies and earned trophies' do
        expect(PSN::Client::User).to receive(:get_profile_from_username)
        expect(PSNAccount).to receive(:create)
        expect(PSN::Services::ImportAccountDefinedTrophies).to receive(:import).with(account.account_id)

        described_class.perform_now(username)
      end
    end
  end
end
