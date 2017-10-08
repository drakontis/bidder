module Bid
  class Device
    include ActiveModel::Model

    attr_accessor :os,
                  :geo
  end
end