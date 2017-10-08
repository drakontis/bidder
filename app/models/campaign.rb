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

  def is_applicable_for_bid_submission?(country:)
    targeted_countries.include?(country) &&
        Bid::BidSubmission.where(campaign_id: id).
            where(created_at: Time.now.beginning_of_minute..Time.now.end_of_minute).count < PER_MINUTE_PACING_LIMIT
  end

  #######
  private
  #######

  def self.fetch_campaigns
    url = 'http://campaigns.apiblueprint.org/campaigns'

    response = RestClient.get(url)

    if response.code == 200
      JSON.parse response.body
    else
      []
    end
  end
end