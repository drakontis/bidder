require 'rails_helper'

describe Bid::BidRequest do
  describe '#initialize' do
    it 'should initialize the application' do
      bid_request = Bid::BidRequest.new(id: 'request_id',
                                        application: Bid::Application.new(id: 'testid', name: 'Super Application'),
                                        device: Bid::Device.new(os: 'Android',
                                                                geo: Bid::Geo.new(country: 'USA',
                                                                                  latitude: 1.212,
                                                                                  longitude: 1.3212)))

      expect(bid_request.id).to eq 'request_id'

      expect(bid_request.application).to be_a Bid::Application
      expect(bid_request.application.id).to eq 'testid'
      expect(bid_request.application.name).to eq 'Super Application'

      expect(bid_request.device).to be_a Bid::Device
      expect(bid_request.device.os).to eq 'Android'

      expect(bid_request.device.geo).to be_a Bid::Geo
      expect(bid_request.device.geo.country).to eq 'USA'
      expect(bid_request.device.geo.latitude).to eq 1.212
      expect(bid_request.device.geo.longitude).to eq 1.3212
    end
  end
end