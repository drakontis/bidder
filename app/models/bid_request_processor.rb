class BidRequestProcessor
  attr_accessor :bid_request,
                :campaigns

  def initialize(json)
    bid_request_builder = Bid::BidRequestBuilder.new(json: json)
    @bid_request = bid_request_builder.build

    @campaigns = Campaign.all
  end

  def process
    matching_campaigns = campaigns.select{ |campaign| campaign.targeted_countries.include? bid_request.device.geo.country }
    winner_campaign = matching_campaigns.max_by(&:price)

    if winner_campaign.present?
      Bid::BidSubmission.new(bid_request_id: bid_request.id,
                            campaign_id: winner_campaign.id,
                            price: winner_campaign.price,
                            adm: winner_campaign.adm)
    else
      nil
    end
  end

end