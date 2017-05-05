require "rails_helper"

describe Api::V1::FlagController, type: :api do
  let!(:target) { create(:survivor) }
  let!(:infected) { create(:survivor, infected: true) }
  let!(:survivors) { create_list(:survivor, 3) }

  describe '#index' do
    let(:params) { { infected_id: target.id, survivor_id: survivors[0].id } }

    it 'should be able to report a survivor' do
      post '/api/v1/flag/infected', params
      expect(last_response.status).to be(204)
    end

    it 'should not be able to report a survivor twice' do
      params = { infected_id: target.id, survivor_id: survivors[0].id }
      post '/api/v1/flag/infected', params
      post '/api/v1/flag/infected', params
      expect(last_response.status).to be(403)
      expect(json['error']).to eql(I18n.t('errors.services.flag.recurrent'))
    end

    it 'should flag survivor as infected on third report' do
      params = { infected_id: target.id, survivor_id: survivors[0].id }
      post '/api/v1/flag/infected', params
      post '/api/v1/flag/infected', params.merge!(survivor_id: survivors[1].id)
      post '/api/v1/flag/infected', params.merge!(survivor_id: survivors[2].id)
      expect(last_response.status).to be(204)
      expect(target.reload.infected?).to be(true)
    end

    it 'should not be able to report an infected survivor' do
      params = { infected_id: infected.id, survivor_id: survivors[0].id }
      post '/api/v1/flag/infected', params
      expect(last_response.status).to be(403)
      expect(json['error']).to eql(I18n.t('errors.services.flag.infected'))
    end

    context "infected survivors" do
      it 'should not be able to report' do
        params = { infected_id: target.id, survivor_id: infected.id }
        post '/api/v1/flag/infected', params
        expect(last_response.status).to be(403)
        expect(json['error']).to eql(I18n.t('errors.services.flag.infected_flagger'))
      end
    end
  end
end
