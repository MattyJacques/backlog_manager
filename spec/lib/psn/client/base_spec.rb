# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Client::Base do
  describe '.get', :vcr do
    context 'when the access token does not exist' do
      it 'retrieves the token and sends the request' do
        result = described_class.get(
          'https://ps5.np.playstation.net/api/trophy/v1/users/6796840136244039860/trophySummary'
        )

        expect(result['accountId']).not_to be_nil
      end
    end

    context 'when access token has expired' do
      it 'refreshes the access token and retries' do
        Rails.cache.write('psn_token', 'fake_expired_token')

        result = described_class.get(
          'https://ps5.np.playstation.net/api/trophy/v1/users/6796840136244039860/trophySummary'
        )

        expect(result['accountId']).not_to be_nil
      end
    end
  end
end
