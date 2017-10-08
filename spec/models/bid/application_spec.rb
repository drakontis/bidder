require 'rails_helper'

describe Bid::Application do
  describe '#initialize' do
    it 'should initialize the application' do
      application = Bid::Application.new(id: 'testid', name: 'Super Application')

      expect(application.id).to eq 'testid'
      expect(application.name).to eq 'Super Application'
    end
  end
end