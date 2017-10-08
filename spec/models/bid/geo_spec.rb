require 'rails_helper'

describe Bid::Geo do
  describe '#initialize' do
    it 'should initialize the device' do
      geo = Bid::Geo.new(country: 'USA',
                         latitude: 1.212,
                         longitude: 1.3212)

      expect(geo).to be_a Bid::Geo
      expect(geo.country).to eq 'USA'
      expect(geo.latitude).to eq 1.212
      expect(geo.longitude).to eq 1.3212
    end
  end
end