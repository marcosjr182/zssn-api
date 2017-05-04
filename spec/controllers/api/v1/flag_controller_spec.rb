require "rails_helper"

describe Api::V1::FlagController, type: :api do
  let!(:target) { create(:survivor) }
  let!(:survivors) { create_list(:survivor, 3) }

  context '#index' do
    let(:params) { { infected_id: target.id, survivor_id: survivors[0].id } }
    it 'should be able to report a survivor' do
      post '/api/v1/flag/infected', params
      expect(last_response.status).to be(204)
    end

    it 'should not be able to report a survivor twice' do
      params = { infected_id: target.id, survivor_id: survivors[0].id }
      post '/api/v1/flag/infected/', params
      post '/api/v1/flag/infected/', params
      expect(last_response.status).to be(403)
    end

    it 'should flag survivor as infected on third report' do
      params = { infected_id: target.id, survivor_id: survivors[0].id }
      post '/api/v1/flag/infected', params
      post '/api/v1/flag/infected', params.merge!(survivor_id: survivors[1].id)
      post '/api/v1/flag/infected', params.merge!(survivor_id: survivors[2].id)
      expect(target.reload.infected?).to be(true)
    end

  end
end
