require 'rails_helper'

describe Campaign do
  describe '#initialize' do
    it 'should initialize the campaign' do
      campaign = Campaign.new(id: '5a3dce46',
                              name: 'Test Campaign 1',
                              price: '1.23',
                              adm: '<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n',
                              targeted_countries: ["USA", "GBR", "GRC"])

      expect(campaign.id).to eq '5a3dce46'
      expect(campaign.name).to eq 'Test Campaign 1'
      expect(campaign.price).to eq '1.23'
      expect(campaign.adm).to eq '<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n'
      expect(campaign.targeted_countries).to eq ["USA", "GBR", "GRC"]
    end
  end

  describe '#all' do
    let(:campaigns_api_response_body) do
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
          }
      ]'
    end

    before do
      campaigns_endpoint = 'http://campaigns.apiblueprint.org/campaigns'
      allow(RestClient).to receive(:get).with(campaigns_endpoint).and_return rest_client_response
    end

    context 'when rest client receives results' do
      let(:rest_client_response) { double('CampaignResponse', code: 200, body: campaigns_api_response_body) }

      it "should return the campaigns" do
        results = Campaign.all

        expect(results).to be_an Array

        first_result = results.first
        expect(first_result).to be_a Campaign
        expect(first_result.id).to eq '5a3dce46'
        expect(first_result.name).to eq 'Test Campaign 1'
        expect(first_result.price).to eq 1.23
        expect(first_result.adm).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
        expect(first_result.targeted_countries).to eq ["USA", "GBR", "GRC"]

        second_result = results.second
        expect(second_result).to be_a Campaign
        expect(second_result.id).to eq 'c56bc77b'
        expect(second_result.name).to eq 'Test Campaign 2'
        expect(second_result.price).to eq 0.45
        expect(second_result.adm).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
        expect(second_result.targeted_countries).to eq ["BRA", "EGY"]

        third_result = results.third
        expect(third_result).to be_a Campaign
        expect(third_result.id).to eq 'a20579a5'
        expect(third_result.name).to eq 'Test Campaign 3'
        expect(third_result.price).to eq 2.21
        expect(third_result.adm).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
        expect(third_result.targeted_countries).to eq ["HUN", "MEX"]
      end
    end

    context 'when rest client receives errors' do
      let(:rest_client_response) { double('CampaignResponse', code: 00, body: campaigns_api_response_body) }

      it "should return empty array" do
        expect(Campaign.all).to eq []
      end
    end
  end

  describe '#fetch_campaigns' do
    let(:campaigns_api_response_body) do
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
          }
      ]'
    end

    before do
      campaigns_endpoint = 'http://campaigns.apiblueprint.org/campaigns'
      allow(RestClient).to receive(:get).with(campaigns_endpoint).and_return rest_client_response
    end

    context 'with response code 200' do
      let(:rest_client_response) { double('CampaignResponse', code: 200, body: campaigns_api_response_body) }

      it 'should return an array with results' do
        result = Campaign.send(:fetch_campaigns)
        expect(result).to be_an Array
        expect(result.count).to eq 3

        first_result = result.first
        expect(first_result).to be_a Hash
        expect(first_result['id']).to eq '5a3dce46'
        expect(first_result['name']).to eq 'Test Campaign 1'
        expect(first_result['price']).to eq 1.23
        expect(first_result['adm']).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
        expect(first_result['targetedCountries']).to eq ["USA", "GBR", "GRC"]

        second_result = result.second
        expect(second_result).to be_a Hash
        expect(second_result['id']).to eq 'c56bc77b'
        expect(second_result['name']).to eq 'Test Campaign 2'
        expect(second_result['price']).to eq 0.45
        expect(second_result['adm']).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
        expect(second_result['targetedCountries']).to eq ["BRA", "EGY"]

        third_result = result.third
        expect(third_result).to be_a Hash
        expect(third_result['id']).to eq 'a20579a5'
        expect(third_result['name']).to eq 'Test Campaign 3'
        expect(third_result['price']).to eq 2.21
        expect(third_result['adm']).to eq "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
        expect(third_result['targetedCountries']).to eq ["HUN", "MEX"]
      end
    end

    context 'with response code 500' do
      let(:rest_client_response) { double('CampaignResponse', code: 500, body: campaigns_api_response_body) }

      it 'should return empty array' do
        expect(Campaign.send(:fetch_campaigns)).to eq []
      end
    end
  end

  describe '#is_applicable_for_bid_submission?' do
    subject { Campaign.new(id: 'camp_id', name: 'Test Campaign 1', price: 1.1, adm: 'test_adm', targeted_countries: ['USA', 'GRC']) }

    context 'When country is included in targeted countries' do
      let(:country){ 'USA' }

      context "when bid submissions with the campaign's id do not exist" do
        before do
          stub_const("Campaign::PER_MINUTE_PACING_LIMIT", 2)

          2.times do |index|
            Bid::BidSubmission.new(bid_request_id: "bid_req_id_#{index+1}", campaign_id: "camp_id_2", price: 1.1, adm: "test_adm").save!
          end
        end

        it 'should return true' do
          expect(subject.is_applicable_for_bid_submission?(country: country)).to be_truthy
        end
      end

      context "when bid submissions with the campaign's id exists" do
        context 'the number of bid submissions is equal to threshold' do
          let(:beginning_of_minute) { Time.new(2017, 10, 8, 20, 40, 0) }
          let(:end_of_minute) { Time.new(2017, 10, 8, 20, 40, 59) }

          before do
            stub_const("Campaign::PER_MINUTE_PACING_LIMIT", 2)

            2.times do |index|
              Bid::BidSubmission.new(bid_request_id: "bid_req_id_#{index+1}", campaign_id: "camp_id", price: 1.1, adm: "test_adm", created_at: beginning_of_minute + (30+index).seconds).save!
            end

            allow(Time).to receive_message_chain(:now, :beginning_of_minute).and_return beginning_of_minute
            allow(Time).to receive_message_chain(:now, :end_of_minute).and_return end_of_minute
          end

          it 'should return false' do
            expect(subject.is_applicable_for_bid_submission?(country: country)).to be_falsy
          end
        end

        context 'the number of bid submissions is less than the threshold' do
          let(:beginning_of_minute) { Time.new(2017, 10, 8, 20, 40, 0) }
          let(:end_of_minute) { Time.new(2017, 10, 8, 20, 40, 59) }

          before do
            stub_const("Campaign::PER_MINUTE_PACING_LIMIT", 2)
            Bid::BidSubmission.new(bid_request_id: "bid_req_id_1", campaign_id: "camp_id", price: 1.1, adm: "test_adm", created_at: beginning_of_minute + 30.seconds).save!
            Bid::BidSubmission.new(bid_request_id: "bid_req_id_1", campaign_id: "camp_id", price: 1.1, adm: "test_adm", created_at: beginning_of_minute + 70.seconds).save!

            allow(Time).to receive_message_chain(:now, :beginning_of_minute).and_return beginning_of_minute
            allow(Time).to receive_message_chain(:now, :end_of_minute).and_return end_of_minute
          end

          it 'should return true' do
            expect(subject.is_applicable_for_bid_submission?(country: country)).to be_truthy
          end
        end
      end
    end

    context 'When country is not included in targeted countries' do
      let(:country){ 'GBR' }

      it 'should return false' do
        expect(subject.is_applicable_for_bid_submission?(country: country)).to be_falsy
      end
    end
  end
end