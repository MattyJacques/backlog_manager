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
end
