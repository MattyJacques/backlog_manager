# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the GamesHelper. For example:
#
# describe GamesHelper do
#   describe 'string concat' do
#     it 'concats two strings with spaces' do
#       expect(helper.concat_strings('this','that')).to eq('this that')
#     end
#   end
# end
RSpec.describe GamesHelper do
  describe '.build_order_link' do
    context 'when session sort_by is empty' do
      let(:expected_link) do
        '<a class="table-dark" href="/games/search?direction=asc&amp;sort_by=name">name</a>'
      end

      it 'returns a link that sorts in ascending order' do
        expect(helper.build_order_link(label: 'name', sort_by: 'name')).to eql(expected_link)
      end
    end

    context 'when session sort_by has a value' do
      let(:expected_link) do
        '<a class="table-dark" href="/games/search?direction=desc&amp;sort_by=name">name</a>'
      end

      before do
        request.session.merge!({ 'game_filters' => { 'sort_by' => 'name' } })
        allow(controller).to receive(:params).and_return({ direction: 'asc' })
      end

      it 'returns a link that sorts in next direction' do
        expect(helper.build_order_link(label: 'name', sort_by: 'name')).to eql(expected_link)
      end
    end
  end

  describe '.sort_indicator' do
    context 'when sorted in ascending order' do
      let(:expected_span) { '<span class="fa-solid fa-sort-up"></span>' }

      before do
        request.session.merge!({ 'game_filters' => { 'direction' => 'asc' } })
      end

      it 'returns an ascending chevron' do
        expect(helper.sort_indicator).to eql(expected_span)
      end
    end

    context 'when sorted in descending order' do
      let(:expected_span) { '<span class="fa-solid fa-sort-down"></span>' }

      before do
        request.session.merge!({ 'game_filters' => { 'direction' => 'desc' } })
      end

      it 'returns an descending chevron icon' do
        expect(helper.sort_indicator).to eql(expected_span)
      end
    end
  end
end
