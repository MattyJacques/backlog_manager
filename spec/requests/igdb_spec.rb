# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/igdb' do
  describe 'GET /index' do
    context 'when there is no search parameter' do
      it 'renders a successful response' do
        get igdb_index_url

        expect(response).to be_successful
      end
    end

    context 'when a search parameter is present' do
      it 'renders a successful response' do
        get igdb_index_url, params: { search: 'The Last of Us' }

        expect(response).to be_successful
      end
    end
  end
end
