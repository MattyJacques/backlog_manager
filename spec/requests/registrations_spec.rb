# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Registrations' do
  describe 'GET /new' do
    it 'returns http success' do
      get new_user_registration_url

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    let(:user) { create(:user) }

    it 'returns http success' do
      sign_in(user)

      get edit_user_registration_url

      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT /update' do
    context 'when user has no linked PSN' do
      let(:user) { create(:user) }
      let(:params) do
        {
          'user[psn_account_attributes][psn_id]': 'ToxicTesting',
          'user[email]': user.email,
          'user[password]': 'NewPassword',
          'user[password_confirmation]': 'NewPassword',
          'user[current_password]': user.password
        }
      end

      it 'returns http success and updates user' do
        sign_in(user)

        put user_registration_url(id: user.id, params:)

        expect(response).to have_http_status(:see_other)
        expect(user.psn_account).to be_present
      end
    end

    context 'when user has a linked PSN' do
      let(:user) { create(:user_with_psn) }
      let(:params) do
        {
          'user[psn_account_attributes][psn_id]': '',
          'user[email]': user.email,
          'user[password]': 'NewPassword',
          'user[password_confirmation]': 'NewPassword',
          'user[current_password]': user.password
        }
      end

      it 'returns http success, updates user and deletes PSN account' do
        sign_in(user)

        put user_registration_url(id: user.id, params:)

        user.reload

        expect(response).to have_http_status(:see_other)
        expect(user.psn_account).to be_nil
      end
    end
  end
end
