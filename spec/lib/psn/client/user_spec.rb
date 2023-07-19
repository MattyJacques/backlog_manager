# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Client::User do
  describe '.get_profile_from_username', :vcr do
    let(:expected_profile_keys) do
      %w[onlineId accountId npId avatarUrls plus aboutMe languagesUsed trophySummary isOfficiallyVerified
         personalDetailSharing personalDetailSharingRequestMessageFlag friendRelation requestMessageFlag blocking
         following]
    end

    it 'returns profile with the given username' do
      response = described_class.get_profile_from_username('Hakoom')

      expect(response.values_at(*expected_profile_keys)).not_to include(nil)
    end
  end

  describe '.get_profile_from_account_id', :vcr do
    let(:expected_keys) do
      %w[onlineId aboutMe avatars languages isPlus isOfficiallyVerified isMe]
    end
    let(:expected_avatars_keys) do
      %w[size url]
    end

    it 'returns profile for given account ID' do
      response = described_class.get_profile_from_account_id('6796840136244039860')

      expect(response.values_at(*expected_keys)).not_to include(nil)
      expect(response['avatars'].first.values_at(*expected_avatars_keys)).not_to include(nil)
    end
  end
end
