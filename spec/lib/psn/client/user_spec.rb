# rubocop:disable RSpec/ExampleLength
# rubocop:disable RSpec/MultipleExpectations
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

  describe '.played_game_data', :vcr do
    let(:expected_keys) do
      %w[titleId name localizedName imageUrl localizedImageUrl category service playCount concept media
         firstPlayedDateTime lastPlayedDateTime playDuration]
    end

    it 'returns the played game data for the given account' do
      response = described_class.played_game_data('5340552997727798155')

      expect(response['titles'].last.values_at(*expected_keys)).not_to include(nil)
    end
  end

  describe '.self_played_data', :vcr do
    it 'returns the played data for the authorised account' do
      response = described_class.self_played_data.first

      expect(response.key?('__typename')).to be(true)
      expect(response.key?('conceptId')).to be(true)
      expect(response.key?('entitlementId')).to be(true)
      expect(response.key?('image')).to be(true)
      expect(response.key?('isActive')).to be(true)
      expect(response.key?('lastPlayedDateTime')).to be(true)
      expect(response.key?('membership')).to be(true)
      expect(response.key?('name')).to be(true)
      expect(response.key?('platform')).to be(true)
      expect(response.key?('productId')).to be(true)
      expect(response.key?('titleId')).to be(true)
    end
  end

  describe '.self_purchased_data', :vcr do
    it 'returns the played data for the authorised account' do
      response = described_class.self_purchased_data.first

      expect(response.key?('__typename')).to be(true)
      expect(response.key?('conceptId')).to be(true)
      expect(response.key?('entitlementId')).to be(true)
      expect(response.key?('image')).to be(true)
      expect(response.key?('isActive')).to be(true)
      expect(response.key?('isDownloadable')).to be(true)
      expect(response.key?('isPreOrder')).to be(true)
      expect(response.key?('membership')).to be(true)
      expect(response.key?('name')).to be(true)
      expect(response.key?('platform')).to be(true)
      expect(response.key?('productId')).to be(true)
      expect(response.key?('titleId')).to be(true)
    end
  end
end

# rubocop:enable RSpec/ExampleLength
# rubocop:enable RSpec/MultipleExpectations
