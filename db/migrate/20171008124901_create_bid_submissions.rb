class CreateBidSubmissions < ActiveRecord::Migration
  def change
    create_table :bid_submissions do |t|
      t.string  :bid_request_id, null: false
      t.string  :campaign_id,    null: false
      t.decimal :price,          null: false
      t.text    :adm,            null: false

      t.timestamps
    end

    add_index :bid_submissions, :bid_request_id, name: 'bid_submissions_bid_request_id_idx'
    add_index :bid_submissions, :campaign_id,    name: 'bid_submissions_campaign_id_idx'
  end
end
