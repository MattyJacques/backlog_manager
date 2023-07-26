# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::ImportDefinedTrophiesJob do
  let(:account) { instance_double(PSNAccount, psn_id: 'Hakoom', account_id: '6796840136244039860') }

  describe '#perform' do
    context 'when account_id exists in database' do
      before do
        allow(PSNAccount).to receive(:find_by).with(psn_id: account.psn_id).and_return(account)
      end

      it 'imports the defined trophies on the account' do
        expect(PSNAccount).to receive(:find_by).with(psn_id: account.psn_id)
        expect(PSN::Client::User).not_to receive(:get_profile_from_username)
        expect(PSN::Services::ImportAccountDefinedTrophies).to receive(:import).with(account.account_id)
        expect(PSN::ScrapeProfileJob).to receive(:perform_now)

        described_class.perform_now('Hakoom', should_scrape: true)
      end
    end

    context 'when account_id does not exist in database' do
      it 'imports the defined trophies on the account', :vcr do
        expect(PSNAccount).to receive(:find_by).with(psn_id: account.psn_id)
        expect(PSN::Client::User).to receive(:get_profile_from_username).and_call_original
        expect(PSN::Services::ImportAccountDefinedTrophies).to receive(:import).with(account.account_id)
        expect(PSN::ScrapeProfileJob).to receive(:perform_now)

        described_class.perform_now('Hakoom', should_scrape: true)
      end
    end
  end
end
