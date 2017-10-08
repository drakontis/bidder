require 'rails_helper'

describe Bid::BidRequestBuilder do

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

  describe '#new' do
    it 'should create a new bid request builder' do
      bid_request_builder = Bid::BidRequestBuilder.new(json: json)

      expect(bid_request_builder).to be_a Bid::BidRequestBuilder
      expect(bid_request_builder).to respond_to :build
    end
  end

  describe '#build' do
    it 'should build a new bid request' do
      bid_request_builder = Bid::BidRequestBuilder.new(json: json)
      bid_request = bid_request_builder.build

      expect(bid_request).to be_a Bid::BidRequest
      expect(bid_request.id).to eq 'e7fe51ce4f6376876353ff0961c2cb0d'

      expect(bid_request.application).to be_an Bid::Application
      expect(bid_request.application.id).to eq 'e7fe51ce-4f63-7687-6353-ff0961c2cb0d'
      expect(bid_request.application.name).to eq 'Morecast Weather'

      expect(bid_request.device).to be_a Bid::Device
      expect(bid_request.device.os).to eq 'Android'

      expect(bid_request.device.geo).to be_a Bid::Geo
      expect(bid_request.device.geo.country).to eq 'USA'
      expect(bid_request.device.geo.latitude).to eq 0
      expect(bid_request.device.geo.longitude).to eq 0
    end
  end
end