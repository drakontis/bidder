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
    pending
  end

  describe '#fetch_campaigns' do
    pending
  end
end