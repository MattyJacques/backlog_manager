# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game do
  subject(:game) { build(:game) }

  it { is_expected.to have_many(:releases).dependent(:destroy) }
  it { is_expected.to have_many(:platforms).through(:releases) }
  it { is_expected.to have_many(:trophy_lists).through(:releases) }
  it { is_expected.to have_many(:game_statuses).dependent(:destroy) }
  it { is_expected.to have_and_belong_to_many(:genres) }

  context 'when validating everything' do
    it 'is valid with valid attributes' do
      expect(game).to be_valid
    end
  end

  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'when validating numericality' do
    it { is_expected.to validate_numericality_of(:igdb_id).allow_nil }
    it { is_expected.to validate_numericality_of(:how_long_to_beat_id).allow_nil }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:igdb_id) }
    it { is_expected.to validate_uniqueness_of(:how_long_to_beat_id) }
  end

  describe '.filter' do
    let(:best_game) do
      instance_double(described_class, id: 1, name: 'Best Game', platforms: [ps3])
    end
    let(:second_best_game) do
      instance_double(described_class, id: 2, name: 'Second Best Game', platforms: [ps4])
    end
    let(:bloatware_game) do
      instance_double(described_class, id: 2, name: 'Bloatware', platforms: [ps4])
    end
    let(:ps3) do
      instance_double(Platform, id: 1, abbreviation: 'PS3')
    end
    let(:ps4) do
      instance_double(Platform, id: 2, abbreviation: 'PS4')
    end
    let(:game_relation) { ActiveRecord::Relation.new(described_class) }

    before do
      allow(described_class).to receive(:includes).with(:trophy_lists, :platforms)
                                                  .and_return(game_relation)
    end

    context 'when there are no search or filters' do
      let(:filters) { {} }
      let(:by_name_games) { [best_game, second_best_game, bloatware_game] }

      before do
        allow(game_relation).to receive(:by_name).with(nil).and_return(by_name_games)
      end

      it 'returns all games' do
        expect(described_class.filter(filters)).to eql(by_name_games)
      end
    end

    context 'when there is a search term' do
      let(:by_name_games) { [best_game, second_best_game] }

      before do
        allow(game_relation).to receive(:by_name).with(filters['name']).and_return(by_name_games)
      end

      context 'when there is no platform filter' do
        let(:filters) { { 'name' => 'game' } }

        it 'returns the games that match the search term' do
          expect(described_class.filter(filters)).to eql(by_name_games)
        end
      end

      context 'when there is a platform filter' do
        let(:filters) { { 'name' => 'game', 'platform_id' => '2' } }
        let(:filtered_games) { [second_best_game] }

        before do
          allow(game_relation).to receive(:by_name).with(filters['name']).and_return(game_relation)
          allow(Platform).to receive(:find).with(ps4.id.to_s).and_return(ps4)
          allow(game_relation).to receive(:select).and_return(filtered_games)
        end

        it 'returns the games that match the term and on the platform' do
          expect(described_class.filter(filters)).to eql(filtered_games)
        end
      end
    end

    context 'when there is a platform filter' do
      let(:filters) { { 'platform_id' => '2' } }
      let(:filtered_games) { [second_best_game, bloatware_game] }

      before do
        allow(game_relation).to receive(:by_name).with(filters['name']).and_return(game_relation)
        allow(Platform).to receive(:find).with(ps4.id.to_s).and_return(ps4)
        allow(game_relation).to receive(:select).and_return(filtered_games)
      end

      it 'returns the games that match the term and on the platform' do
        expect(described_class.filter(filters)).to eql(filtered_games)
      end
    end

    context 'when there is sorting' do
      let(:all_games) { [best_game, second_best_game, bloatware_game] }

      context 'when sorted by name' do
        let(:sorted_games) { [bloatware_game, second_best_game, best_game] }

        before do
          allow(game_relation).to receive(:by_name).with(nil).and_return(game_relation)
        end

        context 'when sorted by asc' do
          let(:filters) { { 'sort_by' => 'name', 'direction' => 'asc' } }

          before do
            allow(game_relation).to receive(:order).with(Arel.sql('lower(games.name) asc'))
                                                   .and_return(sorted_games)
          end

          it 'returns games sorted by name in asc order' do
            expect(described_class.filter(filters)).to eql(sorted_games)
          end
        end

        context 'when sorted by desc' do
          let(:filters) { { 'sort_by' => 'name', 'direction' => 'desc' } }

          before do
            allow(game_relation).to receive(:order).with(Arel.sql('lower(games.name) desc'))
                                                   .and_return(sorted_games.reverse!)
          end

          it 'returns games sorted by name in desc order' do
            expect(described_class.filter(filters)).to eql(sorted_games.reverse!)
          end
        end
      end

      context 'when sorted by platform' do
        let(:sorted_games) { [best_game, second_best_game, bloatware_game] }

        before do
          allow(game_relation).to receive(:by_name).with(nil).and_return(all_games)
        end

        context 'when sorted by asc' do
          let(:filters) { { 'sort_by' => 'platform', 'direction' => 'asc' } }

          it 'returns games sorted by platform in asc order' do
            expect(described_class.filter(filters)).to eql(sorted_games)
          end
        end

        context 'when sorted by desc' do
          let(:filters) { { 'sort_by' => 'platform', 'direction' => 'desc' } }

          it 'returns games sorted by platform in desc order' do
            expect(described_class.filter(filters)).to eql(sorted_games.reverse!)
          end
        end
      end
    end
  end

  describe '#status_for_user' do
    let(:game_status) { build(:game_status) }

    before do
      allow(game.game_statuses).to receive(:find).and_return(game_status)
    end

    it 'returns the status for the user' do
      expect(game.status_for_user(1)).to eql(game_status)
    end
  end
end
