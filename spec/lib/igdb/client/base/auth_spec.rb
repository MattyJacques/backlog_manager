# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::Client::Base::Auth do
  describe '.authenticate' do
    it 'retrieves a new IGDB access token' do
      result = described_class.authenticate

      expect(result).not_to be_nil
    end
  end
end
