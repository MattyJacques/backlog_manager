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
      allow(HTTParty).to receive(:get).with(psnp_list_url).and_return(psnp_response)
    end

    context 'when the PSNP+ list request is successful' do
      let(:gta_iv_unobtainable_ids) { [11, 12] }
      let(:gta_v_unobtainable_ids) { [1, 19] }
      let(:psnp_response) do
        instance_double(HTTParty::Response,
                        success?: true,
                        body: {
                          'version' => 1,
                          'list' => {
                            '404' => gta_iv_unobtainable_ids,
                            '505' => gta_v_unobtainable_ids
                          }
                        })
      end
      let(:gta_iv_list) { instance_double(TrophyList, psnp_id: '404') }
      let(:gta_v_list) { instance_double(TrophyList, psnp_id: '505') }
      let(:trophy_relation) { instance_double(ActiveRecord::Relation) }
      let(:gta_iv_trophy) { instance_double(Trophy) }
      let(:gta_v_trophy) { instance_double(Trophy) }

      before do
        allow(HTTParty).to receive(:get).with(psnp_list_url).and_return(psnp_response)
        allow(TrophyList).to receive(:where).with(psnp_id: psnp_response.body['list'].keys)
                                            .and_return([gta_iv_list, gta_v_list])
        allow(gta_iv_list).to receive(:trophies).and_return(trophy_relation)
        allow(gta_v_list).to receive(:trophies).and_return(trophy_relation)
        allow(trophy_relation).to receive(:where).with(psn_id: gta_iv_unobtainable_ids.map { |id| id - 1 })
                                                 .and_return(trophy_relation)
        allow(trophy_relation).to receive(:where).with(psn_id: gta_v_unobtainable_ids.map { |id| id - 1 })
                                                 .and_return(trophy_relation)
      end

      it 'imports the unobtainable trophies' do
        expect(Spiders::PSNTLUnobtainableDatesSpider).to receive(:process).with(psntl_ids)
        expect(HTTParty).to receive(:get).with(psnp_list_url)
        expect(trophy_relation).to receive(:update!).with(unobtainable: true).twice

        described_class.perform_now
      end
    end

    context 'when the PSNP+ list request has an error' do
      let(:psnp_response) do
        instance_double(HTTParty::Response,
                        success?: false,
                        body: 'It broke')
      end

      it 'raises an error with the PSNP+ error' do
        expect(Spiders::PSNTLUnobtainableDatesSpider).to receive(:process).with(psntl_ids)
        expect(HTTParty).to receive(:get).with(psnp_list_url)

        expect { described_class.perform_now }.to raise_error(RuntimeError)
      end
    end
  end
end
