# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Trophy do
  describe '.title_trophy_list', :vcr do
    context 'when the service name is trophy' do
      let(:expected_result) do
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

      it 'returns the trophy list for the PS3/PS4/PS Vita title' do
        result = described_class.title_trophy_list('NPWR00160_00', 'trophy')

        expect(result[0]).to eql(expected_result)
      end
    end

    context 'when the service name is trophy2' do
      let(:expected_no_progress_result) do
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
      let(:expected_with_progress_result) do
        {
          'trophyId' => 1,
          'trophyHidden' => false,
          'trophyType' => 'gold',
          'trophyName' => 'Warfare Master',
          'trophyDetail' => 'Win 25 Warfare battles.',
          'trophyIconUrl' => 'https://psnobj.prod.dl.playstation.net/psnobj/NPWR22598_00/d380ca49-ecaa-4b24-92e4-3b4e1fdd400f.png',
          'trophyGroupId' => 'default',
          'trophyProgressTargetValue' => '25'
        }
      end

      it 'returns the trophy list for the PS5 title' do
        result = described_class.title_trophy_list('NPWR22598_00', 'trophy2')

        expect(result[0]).to eql(expected_no_progress_result)
        expect(result[1]).to eql(expected_with_progress_result)
      end
    end
  end

  describe '.earned_trophies_for_title', :vcr do
    context 'when the title is a PS3, PS4 or PS Vita title' do
      let(:expected_unearned_result) do
        {
          'trophyId' => 59,
          'trophyHidden' => false,
          'earned' => false,
          'trophyType' => 'silver',
          'trophyRare' => 0,
          'trophyEarnedRate' => '0.4'
        }
      end
      let(:expected_earned_result) do
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
        result = described_class.earned_trophies_for_title('NPWR00160_00', 'trophy', '6796840136244039860')

        expect(result[59]).to eql(expected_unearned_result)
        expect(result[0]).to eql(expected_earned_result)
      end
    end

    context 'when the title is a PS5 title' do
      let(:expected_unearned_result) do
        {
          'trophyId' => 0,
          'trophyHidden' => false,
          'earned' => false,
          'trophyType' => 'platinum',
          'trophyRare' => 0,
          'trophyEarnedRate' => '0.1'
        }
      end
      let(:expected_earned_result) do
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

      it 'returns a list of earned trophies for a single PS5 title' do
        # TODO: Get a result which has an in progress trophy
        result = described_class.earned_trophies_for_title('NPWR22792_00', 'trophy2', '6796840136244039860')

        expect(result[0]).to eql(expected_unearned_result)
        expect(result[1]).to eql(expected_earned_result)
      end
    end
  end

  describe '.all_titles_for_account', :vcr do
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

    context 'when limit is lower than total number of titles' do
      before do
        stub_const('PSN::Trophy::PSN_TITLE_LIMIT', 100)
      end

      it 'returns a list of titles synced to given account' do
        result = described_class.all_titles_for_account('6796840136244039860')

        expect(result.last).to eql(expected_result)
        expect(result.count).to be > 100
      end
    end

    context 'when limit is higher than total number of titles' do
      it 'returns a list of titles synced to given account' do
        result = described_class.all_titles_for_account('6796840136244039860')

        expect(result.last).to eql(expected_result)
        expect(result.count).to be > 100
      end
    end
  end

  describe '.all_trophies', :vcr do
    let(:expected_result) do
      {
        'trophyId' => 16,
        'trophyHidden' => false,
        'earned' => true,
        'earnedDateTime' => '2008-07-16T10:55:47Z',
        'trophyType' => 'gold',
        'trophyRare' => 0,
        'trophyEarnedRate' => '1.2'
      }
    end

    it 'returns a list of all earned trophies for the given account' do
      result = described_class.all_trophies('6796840136244039860')

      expect(result.last).to eql(expected_result)
      expect(result.count).to be > 1
    end
  end
end
