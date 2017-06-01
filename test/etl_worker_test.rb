require 'test_helper'
require 'sidekiq/testing'
require 'webmock/minitest'
Sidekiq::Testing.fake!

module CDMBL
  describe ETLWorker do
    let(:oai_endpoint) { 'http://cdm16022.contentdm.oclc.org/oai/oai.php' }
    let(:cdm_endpoint) { 'https://server16022.contentdm.oclc.org/dmwebservices/index.php' }

    let(:etl_config)   do {
        oai_endpoint: oai_endpoint,
        cdm_endpoint: cdm_endpoint,
        minimum_date: '2012-10-24',
        set_spec: 'p16022coll17',
        field_mappings: false
      }
    end

    let(:solr_config)  { {url: 'http://localhost:8983'} }
    it 'works - a worker sanity check' do
      VCR.use_cassette("etl_worker_integration") do
        ETLWorker.perform_async(solr_config, etl_config, 10, false)
        ETLWorker.drain
      end
    end
  end
end