module Bid
  class BidRequestProcessor
    attr_accessor :bid_request,
                  :campaigns

    def initialize(json)
      bid_request_builder = Bid::BidRequestBuilder.new(json: json)
      @bid_request = bid_request_builder.build

      @campaigns = Campaign.all
    end

    def process
      winner_campaign = find_winner_campaign

      if winner_campaign.present?
        create_bid_submission(winner_campaign)
      else
        nil
      end
    end

    #######
    private
    #######

    def find_winner_campaign
      matching_campaigns = campaigns.select{ |campaign| campaign.targeted_countries.include? bid_request.device.geo.country }
      matching_campaigns.max_by(&:price)
    end

    def create_bid_submission(campaign)
      bid_submission = Bid::BidSubmission.new(bid_request_id: bid_request.id,
                                              campaign_id: campaign.id,
                                              price: campaign.price,
                                              adm: campaign.adm)
      bid_submission.save!
      bid_submission
    rescue
      nil
    end
  end
end