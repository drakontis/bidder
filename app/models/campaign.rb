class Campaign
  include ActiveModel::Model

  PER_MINUTE_PACING_LIMIT = 100

  attr_accessor :id,
                :name,
                :price,
                :adm,
                :targeted_countries

  def self.all
    campaigns = []

    fetch_campaigns.each do |campaign_json|
      campaign = Campaign.new(id: campaign_json['id'],
                              name: campaign_json['name'],
                              price: campaign_json['price'],
                              adm: campaign_json['adm'],
                              targeted_countries: campaign_json['targetedCountries'])

      campaigns << campaign
    end

    campaigns
  end

  def applicable_for_bid_submission?
    Bid::BidSubmission.where(campaign_id: id).where(created_at: Time.now.beginning_of_minute..Time.now.end_of_minute).count < PER_MINUTE_PACING_LIMIT
  end

  #######
  private
  #######

  def self.fetch_campaigns
    url = 'http://campaigns.apiblueprint.org/campaigns'
    # url = 'https://jsonplaceholder.typicode.com/posts'

    response = RestClient.get(url)

    if response.code == 200
      JSON.parse response.body
    else
      []
    end

    # # TODO Remove it
    # response = '[
    #     {
    #         "id": "5a3dce46",
    #         "name": "Test Campaign 1",
    #         "price": 1.23,
    #         "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
    #         "targetedCountries": [
    #             "USA",
    #             "GBR",
    #             "GRC"
    #         ]
    #     },
    #     {
    #         "id": "c56bc77b",
    #         "name": "Test Campaign 2",
    #         "price": 0.45,
    #         "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
    #         "targetedCountries": [
    #             "BRA",
    #             "EGY"
    #         ]
    #     },
    #     {
    #         "id": "a20579a5",
    #         "name": "Test Campaign 3",
    #         "price": 2.21,
    #         "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
    #         "targetedCountries": [
    #             "HUN",
    #             "MEX"
    #         ]
    #     },
    #     {
    #         "id": "e919799e",
    #         "name": "Test Campaign 4",
    #         "price": 0.39,
    #         "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
    #         "targetedCountries": [
    #             "USA"
    #         ]
    #     },
    #     {
    #         "id": "ef88888f",
    #         "name": "Test Campaign 5",
    #         "price": 1.6,
    #         "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
    #         "targetedCountries": [
    #             "GBR"
    #         ]
    #     }
    # ]'
    #
    # JSON.parse response
  end

end