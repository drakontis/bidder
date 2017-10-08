module Bid
  class Application
    include ActiveModel::Model

    attr_accessor :id,
                  :name
  end
end