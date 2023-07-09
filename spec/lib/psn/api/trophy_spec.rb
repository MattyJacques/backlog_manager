# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::API::Trophy do
  describe '.account_summary', :vcr do
    let(:expected_keys) do
      %w[accountId trophyLevel progress tier earnedTrophies]
    end
    let(:expected_earned_trophies_keys) do
      %w[bronze silver gold platinum]
    end

    it 'returns account summary for given account' do
      response = described_class.account_summary('6796840136244039860')

      expect(response.values_at(*expected_keys)).not_to include(nil)
    end
  end

  describe '.account_titles', :vcr do
    let(:expected_result) do
      {
        'npServiceName' => 'trophy',
        'npCommunicationId' => 'NPWR00117_00',
        'trophySetVersion' => '01.12',
        'trophyTitleName' => 'SUPER STARDUST™ HD',
        'trophyTitleDetail' => 'SUPER STARDUST™ HD',
        'trophyTitleIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR00117_00_00E2D6C0A2BB7475BC6C26626F04790CDAD0507E33/797A9F853E90AE722EE315B9A8747E0842390FF3.PNG',
        'trophyTitlePlatform' => 'PS3',
        'hasTrophyGroups' => false,
        'definedTrophies' => { 'bronze' => 9, 'silver' => 6, 'gold' => 2, 'platinum' => 0 },
        'progress' => 100,
        'earnedTrophies' => { 'bronze' => 9, 'silver' => 6, 'gold' => 2, 'platinum' => 0 },
        'hiddenFlag' => false,
        'lastUpdatedDateTime' => '2008-07-16T10:59:08Z'
      }
    end

    it 'returns a list of titles synced to account' do
      response = described_class.account_titles('6796840136244039860', offset: 8380, limit: 800)

      expect(response['trophyTitles'].last).to eql(expected_result)
      expect(response['totalItemCount']).not_to be_nil
    end

    it 'returns a list of titles offset by given amount' do
      expected = described_class.account_titles('6796840136244039860')['trophyTitles']
      response = described_class.account_titles('6796840136244039860', offset: 100)

      expect(response['trophyTitles'][0]).to eq(expected[100])
    end

    it 'returns a list of titles limited by the given value' do
      response = described_class.account_titles('6796840136244039860', limit: 10)

      expect(response['trophyTitles'].count).to eq(10)
    end
  end

  describe '.title_trophy_list', :vcr do
    context 'when there is no account ID provided' do
      let(:expected_keys) do
        %w[trophySetVersion hasTrophyGroups trophies totalItemCount]
      end

      context 'when the title is a PS3, PS4 or PS Vita title' do
        let(:expected_response) do
          {
            'trophyId' => 0,
            'trophyHidden' => false,
            'trophyType' => 'platinum',
            'trophyName' => '100% Complete',
            'trophyDetail' => 'Earn all LittleBigPlanet™ trophies to unlock this platinum trophy',
            'trophyIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR00160_00_008E284646AFE80C3D45BBA5D6763ADDF683823CD4/7CEBBF51CFF811EDCBD664BEEF1CAACC46A2F406.PNG',
            'trophyGroupId' => 'default'
          }
        end

        it 'returns a list of trophies for a single title' do
          response = described_class.title_trophy_list('NPWR00160_00')

          expect(response.values_at(*expected_keys)).not_to include(nil)
          expect(response['trophies'][0]).to eql(expected_response)
        end
      end

      context 'when the title is a PS5 title' do
        let(:expected_response) do
          {
            'trophyId' => 0,
            'trophyHidden' => false,
            'trophyType' => 'platinum',
            'trophyName' => 'General of the Army',
            'trophyDetail' => 'Unlock all Trophies',
            'trophyIconUrl' => 'https://psnobj.prod.dl.playstation.net/psnobj/NPWR22598_00/fd99baeb-9bc5-4a4d-a1e6-ade16e534e04.png',
            'trophyGroupId' => 'default'
          }
        end

        it 'returns a list of trophies for a single title' do
          response = described_class.title_trophy_list('NPWR22598_00', 'trophy2')

          expect(response.values_at(*expected_keys)).not_to include(nil)
          expect(response['trophies'][0]).to eql(expected_response)
        end
      end
    end

    context 'when an account ID is provided' do
      let(:expected_keys) do
        %w[trophySetVersion hasTrophyGroups lastUpdatedDateTime trophies rarestTrophies totalItemCount]
      end

      context 'when the title is a PS3, PS4 or PS Vita title' do
        let(:expected_unearned_response) do
          {
            'trophyId' => 59,
            'trophyHidden' => false,
            'earned' => false,
            'trophyType' => 'silver',
            'trophyRare' => 0,
            'trophyEarnedRate' => '0.4'
          }
        end
        let(:expected_earned_response) do
          {
            'trophyId' => 0,
            'trophyHidden' => false,
            'earned' => true,
            'earnedDateTime' => '2009-05-29T21:01:55Z',
            'trophyType' => 'platinum',
            'trophyRare' => 0,
            'trophyEarnedRate' => '0.4'
          }
        end

        it 'returns a list of earned trophies for a single title' do
          response = described_class.title_trophy_list('NPWR00160_00', 'trophy', '6796840136244039860')

          expect(response.values_at(*expected_keys)).not_to include(nil)
          expect(response['trophies'][59]).to eql(expected_unearned_response)
          expect(response['trophies'][0]).to eql(expected_earned_response)
        end
      end

      context 'when the title is a PS5 title' do
        let(:expected_unearned_response) do
          {
            'trophyId' => 0,
            'trophyHidden' => false,
            'earned' => false,
            'trophyType' => 'platinum',
            'trophyRare' => 0,
            'trophyEarnedRate' => '0.1'
          }
        end
        let(:expected_earned_response) do
          {
            'trophyId' => 1,
            'trophyHidden' => false,
            'earned' => true,
            'earnedDateTime' => '2021-02-02T22:21:43Z',
            'trophyType' => 'bronze',
            'trophyRare' => 1,
            'trophyEarnedRate' => '6.0'
          }
        end

        it 'returns a list of earned trophies for a single title' do
          # TODO: Get a result which has an in progress trophy
          response = described_class.title_trophy_list('NPWR22792_00', 'trophy2', '6796840136244039860')

          expect(response.values_at(*expected_keys)).not_to include(nil)
          expect(response['trophies'][0]).to eql(expected_unearned_response)
          expect(response['trophies'][1]).to eql(expected_earned_response)
        end
      end
    end
  end

  describe '.account_summary_for_title', :vcr do
    let(:expected_response) do
      {
        'titles' =>
        [
          {
            'npTitleId' => 'PPSA07642_00',
            'trophyTitles' =>
            [
              {
                'npServiceName' => 'trophy2',
                'npCommunicationId' => 'NPWR26546_00',
                'trophyTitleName' => 'The Last of Us™ Part I',
                'trophyTitleIconUrl' => 'https://psnobj.prod.dl.playstation.net/psnobj/NPWR26546_00/dea7e1e5-f166-40a8-bc45-87966932a478.png',
                'hasTrophyGroups' => false,
                'rarestTrophies' => [
                  {
                    'trophyId' => 0,
                    'trophyHidden' => false,
                    'trophyType' => 'platinum',
                    'trophyName' => 'It Can\'t Be For Nothing',
                    'trophyDetail' => 'Collect all trophies',
                    'trophyIconUrl' => 'https://psnobj.prod.dl.playstation.net/psnobj/NPWR26546_00/c5e3c1f0-12dc-40f1-8fe7-0514dc034007.png',
                    'trophyRare' => 1,
                    'trophyEarnedRate' => '6.2',
                    'earned' => true,
                    'earnedDateTime' => '2022-10-02T17:34:14Z'
                  }
                ],
                'progress' => 100,
                'earnedTrophies' => { 'bronze' => 14, 'silver' => 7, 'gold' => 7, 'platinum' => 1 },
                'definedTrophies' => { 'bronze' => 14, 'silver' => 7, 'gold' => 7, 'platinum' => 1 },
                'lastUpdatedDateTime' => '2022-10-02T17:34:14Z'
              }
            ]
          }
        ]
      }
    end

    it 'returns a summary of the earned status for a title' do
      response = described_class.account_summary_for_title('6796840136244039860', ['PPSA07642_00'])

      expect(response.to_hash).to eql(expected_response)
    end
  end

  describe '.trophy', :vcr do
    let(:expected_response) do
      {
        'trophySetVersion' => '01.00',
        'trophyId' => 0,
        'trophyHidden' => false,
        'trophyType' => 'platinum',
        'trophyName' => 'Hall of Fame',
        'trophyDetail' => 'Unlock all Destruction AllStars Trophies',
        'trophyIconUrl' => 'https://psnobj.prod.dl.playstation.net/psnobj/NPWR22792_00/22495328-c5ad-4cf1-be7c-e8be615a6c5b.png',
        'trophyGroupId' => 'default',
        'trophyRewardName' => 'Profile Banner',
        'trophyRewardImageUrl' => 'https://psnobj.prod.dl.playstation.net/psnobj/NPWR22792_00/3433d6c0-fa6e-43e1-a557-c4d71f7c2400.png'
      }
    end
    let(:expected_earned_response) do
      {
        'trophyId' => 1,
        'earned' => true,
        'earnedDateTime' => '2021-02-02T22:21:43Z',
        'trophyRare' => 1,
        'trophyEarnedRate' => '6.0'
      }
    end

    it 'returns the general data for a specific trophy' do
      response = described_class.trophy('NPWR22792_00', 0, 'trophy2')

      expect(response.to_hash).to eql(expected_response)
    end

    it 'returns the earned data for the specified account for a specific trophy' do
      response = described_class.trophy('NPWR22792_00', 1, 'trophy2', '6796840136244039860')

      expect(response.to_hash).to eql(expected_earned_response)
    end
  end

  describe '.trophy_groups', :vcr do
    let(:expected_response) do
      {
        'trophySetVersion' => '01.01',
        'trophyTitleName' => 'Mushroom Wars',
        'trophyTitleDetail' => 'Mushroom Wars Trophies',
        'trophyTitleIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR00694_00_003E80EDD2CA0E8B4023DC35B228F5663CE7F2E920/5D95EF11A55642F78D0509BDB3C106429E23380A.PNG',
        'trophyTitlePlatform' => 'PS3',
        'definedTrophies' => { 'bronze' => 18, 'silver' => 5, 'gold' => 0, 'platinum' => 0 },
        'trophyGroups' => [
          {
            'trophyGroupId' => 'default',
            'trophyGroupName' => 'Mushroom Wars',
            'trophyGroupDetail' => 'Mushroom Wars Trophies',
            'trophyGroupIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR00694_00_003E80EDD2CA0E8B4023DC35B228F5663CE7F2E920/5D95EF11A55642F78D0509BDB3C106429E23380A.PNG',
            'definedTrophies' => { 'bronze' => 15, 'silver' => 3, 'gold' => 0, 'platinum' => 0 }
          },
          {
            'trophyGroupId' => '001',
            'trophyGroupName' => 'Mushroom Wars Online',
            'trophyGroupDetail' => 'Mushroom Wars Online Trophies',
            'trophyGroupIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR00694_00_003E80EDD2CA0E8B4023DC35B228F5663CE7F2E920/771646BE851996A1E883BEF6ECF19C55DDF1A22C.PNG',
            'definedTrophies' => { 'bronze' => 3, 'silver' => 2, 'gold' => 0, 'platinum' => 0 }
          }
        ]
      }
    end
    let(:expected_earned_response) do
      {
        'trophySetVersion' => '01.01',
        'hiddenFlag' => false,
        'progress' => 10,
        'earnedTrophies' => { 'bronze' => 3, 'silver' => 0, 'gold' => 0, 'platinum' => 0 },
        'lastUpdatedDateTime' => '2011-10-15T13:30:30Z',
        'trophyGroups' => [
          {
            'trophyGroupId' => 'default',
            'progress' => 14,
            'earnedTrophies' => { 'bronze' => 3, 'silver' => 0, 'gold' => 0, 'platinum' => 0 },
            'lastUpdatedDateTime' => '2011-10-15T11:34:44Z'
          },
          {
            'trophyGroupId' => '001',
            'progress' => 0,
            'earnedTrophies' => { 'bronze' => 0, 'silver' => 0, 'gold' => 0, 'platinum' => 0 }
          }
        ]
      }
    end

    it 'returns the data of trophy groups for a title' do
      response = described_class.trophy_groups('NPWR00694_00', 'trophy')

      expect(response.to_hash).to eql(expected_response)
    end

    it 'returns the earned data for the trophy groups for a title' do
      response = described_class.trophy_groups('NPWR00694_00', 'trophy', '6796840136244039860')

      expect(response.to_hash).to eql(expected_earned_response)
    end
  end
end
