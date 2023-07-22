# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PSNAccounts' do
  let(:account) { PSNAccount.new(psn_id: 'Hakoom', plus: false) }
  let(:trophy_list) { TrophyList.create!(comm_id: 'NPWR12345_00', service: 'trophy2', icon_url: 'trophyicons.com') }

  describe 'GET /index' do
    context 'when some PSNAccount records exist' do
      before do
        game = Game.create!(name: 'Testing 1 2')
        platform = Platform.create!(name: 'Game Player', abbreviation: 'GP')
        Release.create!(game:, platform:)
        AccountTrophyList.create!(psn_account: account, trophy_list:)
      end

      it 'renders a successful response' do
        account.save!

        get psn_accounts_url

        expect(response).to be_successful
      end
    end

    context 'when no PSNAccount records exist' do
      it 'renders a successful response' do
        get psn_accounts_url

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    context 'when the PSNAccount record exists' do
      before do
        AccountTrophyList.create!(psn_account: account, trophy_list:)
        trophy = Trophy.create!(psn_id: 0,
                                name: 'So Shiny',
                                detail: 'Earn it',
                                icon_url: 'image.com/trophy',
                                rank: 0,
                                trophy_list:)
        EarnedTrophy.create!(psn_account: account, trophy_list:, trophy:)
      end

      it 'renders a successful response' do
        account.save!

        get psn_account_url(account)

        expect(response).to be_successful
      end
    end

    context 'when the PSNAccount record does not exist' do
      it 'redirects to index url' do
        get psn_account_url(100)

        expect(response).to redirect_to(psn_accounts_url)
      end
    end
  end
end
