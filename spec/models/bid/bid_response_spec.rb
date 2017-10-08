require 'rails_helper'

describe Bid::BidSubmission do
  describe '#initialize' do
    it 'should initialize the bid submission' do
      bid_submission = Bid::BidSubmission.new(bid_request_id: '5a3dce46',
                                              campaign_id: 'CampaignID',
                                              price: 1.23,
                                              adm: '<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n')

      expect(bid_submission.bid_request_id).to eq '5a3dce46'
      expect(bid_submission.campaign_id).to eq 'CampaignID'
      expect(bid_submission.price).to eq 1.23
      expect(bid_submission.adm).to eq '<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n'
    end
  end
end