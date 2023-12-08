# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TrophyListsHelper. For example:
#
# describe TrophyListsHelper do
#   describe 'string concat' do
#     it 'concats two strings with spaces' do
#       expect(helper.concat_strings('this','that')).to eq('this that')
#     end
#   end
# end
RSpec.describe TrophyListsHelper do
  describe '.trophy_rank_icon' do
    let(:expected_tag) do
      '<img width="40" height="40" alt="bronze" ' \
        'src="/assets/psn/bronze-trophy-1d2e36973a38339d56333f0394818e74814db0f7810d76b2485ec4b054148625.png" />'
    end

    context 'when rank is bronze' do
      let(:expected_tag) do
        '<img width="40" height="40" alt="bronze" ' \
          'src="/assets/psn/bronze-trophy-1d2e36973a38339d56333f0394818e74814db0f7810d76b2485ec4b054148625.png" />'
      end

      it 'returns a tag with the bronze trophy image' do
        expect(helper.trophy_rank_icon('bronze')).to eql(expected_tag)
      end
    end

    context 'when rank is silver' do
      let(:expected_tag) do
        '<img width="40" height="40" alt="silver" ' \
          'src="/assets/psn/silver-trophy-2df0006054b65f7e86f7d79b9aad6d4569e98c00c654ca41acfce34f1b172a97.png" />'
      end

      it 'returns a tag with the silver trophy image' do
        expect(helper.trophy_rank_icon('silver')).to eql(expected_tag)
      end
    end

    context 'when rank is gold' do
      let(:expected_tag) do
        '<img width="40" height="40" alt="gold" ' \
          'src="/assets/psn/gold-trophy-d7e4daf8b18d976d40b039d3aafc00608d0c62d922d51f59c572394cc32eef53.png" />'
      end

      it 'returns a tag with the gold trophy image' do
        expect(helper.trophy_rank_icon('gold')).to eql(expected_tag)
      end
    end

    context 'when rank is platinum' do
      let(:expected_tag) do
        '<img width="40" height="40" alt="platinum" ' \
          'src="/assets/psn/platinum-trophy-e02d0c9ca38ba209a5881ec688cf6bc69a28d42ff0c72170d466b37bff9cabeb.png" />'
      end

      it 'returns a tag with the platinum trophy image' do
        expect(helper.trophy_rank_icon('platinum')).to eql(expected_tag)
      end
    end
  end

  describe '.hidden_icon' do
    let(:expected_tag) { '<i class="fa-regular fa-eye-slash"></i>' }

    it 'returns the hidden trophy icon' do
      expect(helper.hidden_icon).to eql(expected_tag)
    end
  end
end
