class BidRequestsController < ApplicationController
  def create
    processor = Bid::BidRequestProcessor.new(params['bid_request'])
    bid_responce = processor.process

    if bid_responce.present?
      render json: {id: bid_responce.bid_request_id,
                    bid: {campaignId: bid_responce.campaign_id,
                          price: bid_responce.price.to_f,
                          adm: bid_responce.adm}}, status: 200
    else
      render json: {}, status: 204
    end
  end
end