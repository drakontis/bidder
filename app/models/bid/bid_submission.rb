module Bid
  class BidSubmission
    include ActiveModel::Model

    attr_accessor :bid_request_id,
                  :campaign_id,
                  :price,
                  :adm
  end
end