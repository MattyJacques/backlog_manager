# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PSNAccounts' do
  describe 'GET /index' do
    context 'when some PSNAccount records exist' do
      let(:account_no_lists) { create(:psn_account) }
      let(:account_with_lists) { create(:psn_account) }
      let(:game) { create(:game_with_trophies) }
      let(:account_trophy_list) do
        create(:account_trophy_list, psn_account: account_with_lists, trophy_list: game.trophy_lists.first)
      end

      before do
        create_list(:earned_trophy, 5, account_trophy_list:)
      end

      it 'renders a successful response' do
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
      let(:account) { create(:psn_account) }

      context 'when PSNAccount has trophies' do
        let(:game) { create(:game_with_trophies) }
        let(:account_trophy_list) do
          create(:account_trophy_list, psn_account: account, trophy_list: game.trophy_lists.first)
        end

        before do
          create_list(:earned_trophy, 5, account_trophy_list:)
        end

        it 'renders a successful response' do
          get psn_account_url(account)

          expect(response).to be_successful
        end
      end

      context 'when PSNAccount has no trophies' do
        let(:account) { create(:psn_account) }

        it 'renders a successful response' do
          get psn_account_url(account)

          expect(response).to be_successful
        end
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
