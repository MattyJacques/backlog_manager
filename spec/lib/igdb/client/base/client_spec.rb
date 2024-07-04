# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::Client::Base::Client do
  describe '.post' do
    let(:params) { { fields: 'name', where: "id = #{id}" } }
    let(:id) { 1009 }

    context 'when the access token does not exist' do
      it 'retrives the token and posts the request' do
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

        result = described_class.post('games', params).first

        expect(result['name']).to eq('The Last of Us')
        expect(result['id']).to eq(1009)
      end
    end

    context 'when there is an error' do
      let(:id) { 0 }

      it 'raises IGDB::Client::Errors::NotFound' do
        expect do
          described_class.post('games', params)
        end.to raise_error(IGDB::Client::Errors::NotFound)
      end
    end
  end
end
