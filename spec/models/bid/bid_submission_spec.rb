require 'rails_helper'

describe Bid::BidSubmission do
  describe 'Validations' do
    it 'should be valid if all validations met' do
      subject.bid_request_id = 'bidrequestid'
      subject.campaign_id = 'campaignid'
      subject.price = 1.23
      subject.adm = 'testadm'

      expect(subject).to be_valid
    end

    it 'should not be valid if bid_request_id is empty' do
      subject.bid_request_id = nil
      subject.campaign_id = 'campaignid'
      subject.price = 1.23
      subject.adm = 'testadm'

      expect(subject).not_to be_valid
    end

    it 'should not be valid if campaign_id is empty' do
      subject.bid_request_id = 'bidrequestid'
      subject.campaign_id = nil
      subject.price = 1.23
      subject.adm = 'testadm'

      expect(subject).not_to be_valid
    end

    it 'should not be valid if price is empty' do
      subject.bid_request_id = 'bidrequestid'
      subject.campaign_id = 'campaignid'
      subject.price = nil
      subject.adm = 'testadm'

      expect(subject).not_to be_valid
    end

    it 'should not be valid if adm is empty' do
      subject.bid_request_id = 'bidrequestid'
      subject.campaign_id = 'campaignid'
      subject.price = 1.23
      subject.adm = nil

      expect(subject).not_to be_valid
    end
  end

  describe '#save' do
    it 'should save the bid submission' do
      subject.bid_request_id = 'bidrequestid'
      subject.campaign_id = 'campaignid'
      subject.price = 1.23
      subject.adm = 'testadm'

      expect do
        subject.save
      end.to change{Bid::BidSubmission.count}.by 1

      subject.reload

      expect(subject).to be_persisted

      expect(subject.bid_request_id).to eq 'bidrequestid'
      expect(subject.campaign_id).to eq 'campaignid'
      expect(subject.price).to eq 1.23
      expect(subject.adm).to eq 'testadm'
    end
  end
end