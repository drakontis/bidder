module Bid
  class BidRequest
    include ActiveModel::Model

    attr_accessor :id,
                  :application,
                  :device
  end
end