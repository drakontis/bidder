module Bid
  class Geo
    include ActiveModel::Model

    attr_accessor :country,
                  :latitude,
                  :longitude
  end
end