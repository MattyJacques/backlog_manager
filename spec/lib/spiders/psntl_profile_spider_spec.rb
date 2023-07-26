# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spiders::PSNTLProfileSpider, spider_specs: true do
  let(:expected_result) do
    [
      { id: '3-on-3-nhl-arcade-ps3', date: '2012-07-24 23:07:51' },
      { id: 'killzone-2-ps3', date:  '2009-06-07 20:59:40' },
      { id: 'gta-iv-ps3', date: '2009-02-24 20:57:09' }
    ]
  end

  describe '.process' do
    it 'scrapes profile for PSNP ids' do
      expect(described_class.process('STOPHY821')).to eql(expected_result)
    end
  end
end
