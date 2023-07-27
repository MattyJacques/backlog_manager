# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::ImportUnobtainableTrophiesJob do
  describe '#perform' do
    let(:trophy_list_relation) { instance_double(ActiveRecord::Relation) }
    let(:trophy_list_query) { instance_double(ActiveRecord::QueryMethods::WhereChain) }
    let(:gta_iv_psntl) { 'grand-theft-auto-iv-ps3' }
    let(:gta_v_psntl) { 'grand-theft-auto-v-ps4' }
    let(:psntl_ids) { [gta_iv_psntl, gta_v_psntl] }
    let(:psnp_list_url) { 'https://psnp-plus.netlify.app/list.min.json' }

    before do
      allow(TrophyList).to receive(:where).and_return(trophy_list_query)
      allow(trophy_list_query).to receive(:not).and_return(trophy_list_relation)
      allow(trophy_list_relation).to receive(:where).and_return(trophy_list_relation)
      allow(trophy_list_relation).to receive(:pluck).with(:psntl_id).and_return(psntl_ids)
    end

    context 'when the PSNP+ list request is successful', :vcr do
      let(:gta_iv_list) { instance_double(TrophyList, psnp_id: '13') }
      let(:gta_v_list) { instance_double(TrophyList, psnp_id: '20') }
      let(:trophy_relation) { instance_double(ActiveRecord::Relation) }
      let(:gta_iv_trophy) { instance_double(Trophy) }
      let(:gta_v_trophy) { instance_double(Trophy) }

      before do
        allow(TrophyList).to receive(:where).with(psnp_id: anything)
                                            .and_return([gta_iv_list, gta_v_list])
        allow(gta_iv_list).to receive(:trophies).and_return(trophy_relation)
        allow(gta_v_list).to receive(:trophies).and_return(trophy_relation)
        allow(trophy_relation).to receive(:where).with(psn_id: anything)
                                                 .and_return(trophy_relation)
        allow(trophy_relation).to receive(:where).with(psn_id: anything)
                                                 .and_return(trophy_relation)
      end

      it 'imports the unobtainable trophies' do
        expect(Spiders::PSNTLUnobtainableDatesSpider).to receive(:process).with(psntl_ids)
        expect(HTTParty).to receive(:get).with(psnp_list_url).and_call_original
        expect(trophy_relation).to receive(:update!).with(unobtainable: true).twice

        described_class.perform_now
      end
    end

    context 'when the PSNP+ list request has an error' do
      let(:psnp_response) { instance_double(HTTParty::Response, success?: false) }

      before do
        allow(HTTParty).to receive(:get).with(psnp_list_url).and_return(psnp_response)
      end

      it 'raises an error with the PSNP+ error' do
        expect(Spiders::PSNTLUnobtainableDatesSpider).to receive(:process).with(psntl_ids)
        expect(HTTParty).to receive(:get).with(psnp_list_url)

        expect { described_class.perform_now }.to raise_error(RuntimeError)
      end
    end
  end
end
