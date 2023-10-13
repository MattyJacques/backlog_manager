# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it { is_expected.to have_many(:game_statuses).dependent(:destroy) }

  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
  end

  context 'when accepting attributes' do
    context 'with psn_account attributes' do
      it { is_expected.to accept_nested_attributes_for(:psn_account).allow_destroy(true) }

      it 'is invalid if no psn_id given' do
        user = build(:user)
        user.update({ psn_account_attributes: { psn_id: '' } })

        expect(user.psn_account).to be_nil
      end
    end
  end
end
