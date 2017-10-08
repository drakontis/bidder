module Bid
  class BidRequestBuilder
    include ActiveModel::Model

    attr_accessor :json

    def build
      Bid::BidRequest.new(id: json['id'],
                          application: build_application(json['app']),
                          device: build_device(json['device']))

    end

    #######
    private
    #######

    def build_application(json)
      Application.new(id: json['id'],
                      name: json['name'])
    end

    def build_device(json)
      Device.new(os: json['os'],
                 geo: build_geo(json['geo']))
    end

    def build_geo(json)
      Geo.new(country: json['country'],
              latitude: json['lat'],
              longitude: json['lon'])
    end
  end
end