require 'rails_helper'

describe Bid::BidRequestProcessor do

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

  describe '#initialize' do
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

    context 'with response code 200' do
      let(:rest_client_response) do
        double('CampaignResponse', code: 200, body: campaigns_api_response_body)
      end

      it 'should initialize the processor' do
        processor = Bid::BidRequestProcessor.new(json)

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
        processor = Bid::BidRequestProcessor.new(json)

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

    context 'with response code 200' do
      let(:rest_client_response) do
        double('CampaignResponse', code: 200, body: campaigns_api_response_body)
      end

      it 'should return the bid response and save the bid submission' do
        process_result = nil

        expect do
          process_result = Bid::BidRequestProcessor.new(json).process
        end.to change{Bid::BidSubmission.count}.by 1

        expect(process_result).to be_a Bid::BidSubmission
        expect(process_result).to be_persisted
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
        process_result = nil

        expect do
          process_result = Bid::BidRequestProcessor.new(json).process
        end.not_to change{ Bid::BidSubmission.count }

        expect(process_result).to be_nil
      end
    end
  end

  describe '#find_winner_campaign' do
    let(:campaign_1){ Campaign.new(id: 'CampaignId1',
                                   name: 'CamnpaingName1',
                                   price: 1.23,
                                   adm: 'adm1',
                                   targeted_countries:['USA', 'GRC']) }

    let(:campaign_2){ Campaign.new(id: 'CampaignId2',
                                   name: 'CamnpaingName2',
                                   price: 2.23,
                                   adm: 'adm2',
                                   targeted_countries:['GBR']) }

    let(:campaign_3){ Campaign.new(id: 'CampaignId3',
                                   name: 'CamnpaingName3',
                                   price: 3.23,
                                   adm: 'adm3',
                                   targeted_countries:['CPY']) }

    let(:bid_request){ Bid::BidRequest.new(id: 'request_id',
                                           application: Bid::Application.new(id: 'testid', name: 'Super Application'),
                                           device: Bid::Device.new(os: 'Android',
                                                                   geo: Bid::Geo.new(country: 'USA',
                                                                                     latitude: 1.212,
                                                                                     longitude: 1.3212))) }

    before do
      allow(Campaign).to receive(:all).and_return [campaign_1, campaign_2, campaign_3]

      expect(campaign_1).to receive(:is_applicable_for_bid_submission?).with(country: bid_request.device.geo.country).and_return true
      expect(campaign_2).to receive(:is_applicable_for_bid_submission?).with(country: bid_request.device.geo.country).and_return false
      expect(campaign_3).to receive(:is_applicable_for_bid_submission?).with(country: bid_request.device.geo.country).and_return true
    end

    it 'should return the campaign with the biggest price' do
      bid_request_processor = Bid::BidRequestProcessor.new(json)
      expect(bid_request_processor.send(:find_winner_campaign)).to eq campaign_3
    end
  end

  describe '#create_bid_submission' do
    let(:campaign){ Campaign.new(id: 'CampaignId1',
                                 name: 'CamnpaingName1',
                                 price: 1.23,
                                 adm: 'adm1',
                                 targeted_countries:['USA', 'GRC']) }

    before { allow(Campaign).to receive(:all).and_return [campaign] }


    it 'should create a bid submission' do
      bid_request_processor = Bid::BidRequestProcessor.new(json)

      expect do
        bid_request_processor.send(:create_bid_submission, campaign)
      end.to change{Bid::BidSubmission.count}.by 1

      bid_submission = Bid::BidSubmission.last
      expect(bid_submission.bid_request_id).to eq 'e7fe51ce4f6376876353ff0961c2cb0d'
      expect(bid_submission.campaign_id).to eq 'CampaignId1'
      expect(bid_submission.price).to eq 1.23
      expect(bid_submission.adm).to eq 'adm1'
    end
  end
end