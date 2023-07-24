# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TrophyLists' do
  let(:trophy_list) { TrophyList.create!(comm_id: 'NPWR12345_00', service: 'trophy2', icon_url: 'trophyicons.com') }

  describe 'GET /index' do
    context 'when some TrophyList records exist' do
      it 'returns a successful response' do
        trophy_list.save!

        get trophy_lists_url

        expect(response).to be_successful
      end
    end

    context 'when no TrophyList records exist' do
      it 'renders a successful response' do
        get psn_accounts_url

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    context 'when the TrophyList record exists' do
      it 'renders a successful response' do
        get trophy_list_url(trophy_list)

        expect(response).to be_successful
      end
    end

    context 'when the TrophyList record does not exist' do
      it 'redirects to index url' do
        get trophy_list_url(100)

        expect(response).to redirect_to(trophy_lists_url)
      end
    end
  end
end
