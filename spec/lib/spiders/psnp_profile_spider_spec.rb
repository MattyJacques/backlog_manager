# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spiders::PSNPProfileSpider, spider_specs: true do
  let(:expected_result) do
    [
      { name: 'Fallout 3', psnp_id: '48' },
      { name: 'The Evil Within', psnp_id: '2978' },
      { name: 'Call of Duty: Black Ops', psnp_id: '436' }
    ]
  end

  describe '.process' do
    it 'scrapes profile for PSNP ids' do
      expect(described_class.process('TestingGame00')).to eql(expected_result)
    end
  end
end
