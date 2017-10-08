require 'rails_helper'

describe BidRequestsController, :type => :controller do

  let(:rest_client_response) do
    double('CampaignResponse', code: 200, body: campaigns_api_response_body)
  end

  before do
    campaigns_endpoint = 'http://campaigns.apiblueprint.org/campaigns'
    allow(RestClient).to receive(:get).with(campaigns_endpoint).and_return rest_client_response
  end

  context 'with matching campaign' do
    let(:bid_request_json) do
      {
          "id": "e7fe51ce4f6376876353ff0961c2cb0d",
          "app": {
              "id": "e7fe51ce-4f63-7687-6353-ff0961c2cb0d",
              "name": "Morecast Weather"
          },
          "device": {
              "os": "Android",
              "geo": {
                  "country": "USA",
                  "lat": 0,
                  "lon": 0
              }
          }
      }
    end

    let(:campaigns_api_response_body){
      '[
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

    let(:expected_body){
      {
          "id": "e7fe51ce4f6376876353ff0961c2cb0d",
          "bid": {
              "campaignId": "5a3dce46",
              "price": 1.23,
              "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n"
          }
      }
    }

    it 'should respond with a bid' do
      post :create, {bid_request: bid_request_json}

      expect(response.status).to eq 200
      expect((JSON.parse(response.body).as_json)).to eq expected_body.as_json
    end
  end

  context 'without matching campaign' do
    let(:bid_request_json) do
      {
          "id": "e7fe51ce4f6376876353ff0961c2cb0d",
          "app": {
              "id": "e7fe51ce-4f63-7687-6353-ff0961c2cb0d",
              "name": "Morecast Weather"
          },
          "device": {
              "os": "Android",
              "geo": {
                  "country": "CYP",
                  "lat": 0,
                  "lon": 0
              }
          }
      }
    end

    let(:campaigns_api_response_body) do
      '[
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
    end

    let(:expected_body) { {} }

    it 'should respond with a bid' do
      post :create, {bid_request: bid_request_json}

      expect(response.status).to eq 204
      expect((JSON.parse(response.body).as_json)).to eq expected_body.as_json
    end
  end
end