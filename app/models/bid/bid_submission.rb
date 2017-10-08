module Bid
  class BidSubmission < ActiveRecord::Base
    validates :bid_request_id, presence: true
    validates :campaign_id,    presence: true
    validates :price,          presence: true
    validates :adm,            presence: true
  end
end