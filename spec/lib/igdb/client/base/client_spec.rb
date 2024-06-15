# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::Client::Base::Client do
  describe '.post' do
    context 'when the access token does not exist' do
      it 'retrives the token and posts the request' do
        params = { fields: 'name', where: 'id = 1009' }
        result = described_class.post('games', params).first

        expect(result['name']).to eq('The Last of Us')
        expect(result['id']).to eq(1009)
      end
    end

    context 'when access token has expired' do
      before do
        Rails.cache.write('igdb_token', 'fake_expired_token')
      end

      it 'refreshes the access token and retries' do
        expect(Rails.cache).to receive(:delete).with('igdb_token').and_call_original

        params = { fields: 'name', where: 'id = 1009' }
        result = described_class.post('games', params).first

        expect(result['name']).to eq('The Last of Us')
        expect(result['id']).to eq(1009)
      end
    end
  end
end
