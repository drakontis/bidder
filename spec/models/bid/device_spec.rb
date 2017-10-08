require 'rails_helper'

describe Bid::Device do
  describe '#initialize' do
    it 'should initialize the device' do
      device = Bid::Device.new(os: 'Android',
                               geo: Bid::Geo.new(country: 'USA',
                                                 latitude: 1.212,
                                                 longitude: 1.3212))


      expect(device).to be_a Bid::Device
      expect(device.os).to eq 'Android'
      expect(device.geo).to be_a Bid::Geo
      expect(device.geo.country).to eq 'USA'
      expect(device.geo.latitude).to eq 1.212
      expect(device.geo.longitude).to eq 1.3212
    end
  end
end