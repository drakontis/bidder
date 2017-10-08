require 'rails_helper'

describe BidRequestProcessor do

  let(:json){
    {"id" => "e7fe51ce4f6376876353ff0961c2cb0d",
     "app" => {
         "id" => "e7fe51ce-4f63-7687-6353-ff0961c2cb0d",
         "name" => "Morecast Weather"
     },
     "device" => {
         "os" => "Android",
         "geo" => {
             "country" => "USA",
             "lat" => 0,
             "lon" => 0
         }
     }}
  }

  let(:campaigns_api_response_body){
    '[
        {
            "id": "5a3dce46",
            "name": "Test Campaign 1",
            "price": 1.23,
            "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
            "targetedCountries": [
                "USA",
                "GBR",
                "GRC"
            ]
        },
        {
            "id": "c56bc77b",
            "name": "Test Campaign 2",
            "price": 0.45,
            "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
            "targetedCountries": [
                "BRA",
                "EGY"
            ]
        },
        {
            "id": "a20579a5",
            "name": "Test Campaign 3",
            "price": 2.21,
            "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
            "targetedCountries": [
                "HUN",
                "MEX"
            ]
        },
        {
            "id": "e919799e",
            "name": "Test Campaign 4",
            "price": 0.39,
            "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
            "targetedCountries": [
                "USA"
            ]
        },
        {
            "id": "ef88888f",
            "name": "Test Campaign 5",
            "price": 1.6,
            "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
            "targetedCountries": [
                "GBR"
            ]
        }
    ]'
  }

  before do
    campaigns_endpoint = 'http://campaigns.apiblueprint.org/campaigns'

    allow(RestClient).to receive(:get).with(campaigns_endpoint).and_return rest_client_response
  end

  describe '#initialize' do
    context 'with response code 200' do
      let(:rest_client_response) do
        double('CampaignResponse', code: 200, body: campaigns_api_response_body)
      end

      it 'should initialize the processor' do
        processor = BidRequestProcessor.new(json)

        expect(processor.bid_request).to be_a Bid::BidRequest
        expect(processor.bid_request.id).to eq 'e7fe51ce4f6376876353ff0961c2cb0d'

        expect(processor.bid_request.application).to be_an Bid::Application
        expect(processor.bid_request.application.id).to eq 'e7fe51ce-4f63-7687-6353-ff0961c2cb0d'
        expect(processor.bid_request.application.name).to eq 'Morecast Weather'

        expect(processor.bid_request.device).to be_a Bid::Device
        expect(processor.bid_request.device.os).to eq 'Android'

        expect(processor.bid_request.device.geo).to be_a Bid::Geo
        expect(processor.bid_request.device.geo.country).to eq 'USA'
        expect(processor.bid_request.device.geo.latitude).to eq 0
        expect(processor.bid_request.device.geo.longitude).to eq 0

        expect(processor.campaigns).to be_an Array
        expect(processor.campaigns.size).to eq 5

        first_campaign = processor.campaigns.first
        expect(first_campaign.id).to eq '5a3dce46'
        expect(first_campaign.name).to eq 'Test Campaign 1'
        expect(first_campaign.price).to eq 1.23
        expect(first_campaign.adm).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
        expect(first_campaign.targeted_countries).to eq ["USA", "GBR", "GRC"]

        second_campaign = processor.campaigns.second
        expect(second_campaign.id).to eq 'c56bc77b'
        expect(second_campaign.name).to eq 'Test Campaign 2'
        expect(second_campaign.price).to eq 0.45
        expect(second_campaign.adm).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
        expect(second_campaign.targeted_countries).to eq ["BRA", "EGY"]

        third_campaign = processor.campaigns.third
        expect(third_campaign.id).to eq 'a20579a5'
        expect(third_campaign.name).to eq 'Test Campaign 3'
        expect(third_campaign.price).to eq 2.21
        expect(third_campaign.adm).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
        expect(third_campaign.targeted_countries).to eq ["HUN", "MEX"]

        fourth_campaign = processor.campaigns.fourth
        expect(fourth_campaign.id).to eq 'e919799e'
        expect(fourth_campaign.name).to eq 'Test Campaign 4'
        expect(fourth_campaign.price).to eq 0.39
        expect(fourth_campaign.adm).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
        expect(fourth_campaign.targeted_countries).to eq ["USA"]

        fifth_campaign = processor.campaigns.fifth
        expect(fifth_campaign.id).to eq 'ef88888f'
        expect(fifth_campaign.name).to eq 'Test Campaign 5'
        expect(fifth_campaign.price).to eq 1.6
        expect(fifth_campaign.adm).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
        expect(fifth_campaign.targeted_countries).to eq ["GBR"]
      end
    end

    context 'with response code 500' do
      let(:rest_client_response) do
        double('CampaignResponse', code: 500, body: 'Internal server error')
      end

      it 'should initialize the processor' do
        processor = BidRequestProcessor.new(json)

        expect(processor.bid_request).to be_a Bid::BidRequest
        expect(processor.bid_request.id).to eq 'e7fe51ce4f6376876353ff0961c2cb0d'

        expect(processor.bid_request.application).to be_an Bid::Application
        expect(processor.bid_request.application.id).to eq 'e7fe51ce-4f63-7687-6353-ff0961c2cb0d'
        expect(processor.bid_request.application.name).to eq 'Morecast Weather'

        expect(processor.bid_request.device).to be_a Bid::Device
        expect(processor.bid_request.device.os).to eq 'Android'

        expect(processor.bid_request.device.geo).to be_a Bid::Geo
        expect(processor.bid_request.device.geo.country).to eq 'USA'
        expect(processor.bid_request.device.geo.latitude).to eq 0
        expect(processor.bid_request.device.geo.longitude).to eq 0

        expect(processor.campaigns).to be_an Array
        expect(processor.campaigns).to be_empty
      end
    end
  end

  describe '#process' do
    context 'with response code 200' do
      let(:rest_client_response) do
        double('CampaignResponse', code: 200, body: campaigns_api_response_body)
      end

      it 'should return the bid response' do
        process_result = BidRequestProcessor.new(json).process

        expect(process_result).to be_a Bid::BidSubmission
        expect(process_result.bid_request_id).to eq 'e7fe51ce4f6376876353ff0961c2cb0d'
        expect(process_result.campaign_id).to eq '5a3dce46'
        expect(process_result.price).to eq 1.23
        expect(process_result.adm).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
      end
    end

    context 'with response code 500' do
      let(:rest_client_response) do
        double('CampaignResponse', code: 500, body: 'Internal Server Error')
      end

      it 'should return empty bid submission' do
        process_result = BidRequestProcessor.new(json).process

        expect(process_result).to be_nil
      end
    end
  end
end