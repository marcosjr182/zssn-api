require "rails_helper"

describe Api::V1::SurvivorsController, :type => :api do
  let!(:survivor) { create(:survivor) }

  context '#create' do
    it 'should create a survivor' do
      survivor_params = {survivor: {name: 'Test'}}
      post '/api/v1/survivors', survivor_params
      expect(last_response.status).to be(201)
    end

    it 'should not create a survivor without a name' do
      survivor_params = {survivor: {water: 0, food: 1, age: 10}}
      post '/api/v1/survivors', survivor_params
      expect(last_response.status).to be(422)
    end
  end

  context '#index' do
    it "GET index" do
      get '/api/v1/survivors'
      survivor = SurvivorSerializer.new(survivor)
      expect(last_response.status).to eql(200)
    end

    it "can take a page as parameter" do
      get "/api/v1/survivors", { :page => 2 }
      expect(last_response.status).to eql(200)
      expect(json['survivors']).to be_empty
    end
  end

  context '#update' do
    it 'should update only the location for valid users' do
      params = {survivor: { name: 'Test', lat: 5.5, lng: 1.1 }}
      patch "api/v1//survivors/#{survivor.id}", params
      expect(last_response.status).to be(200)
      expect(json['survivor']['name']).to eq(survivor.name)
    end
  end

  context '#report' do
    let!(:target) { create(:survivor) }
    let!(:survivors) { create_list(:survivor, 3) }

    it 'should be able to report a survivor' do
      params = { infected_id: target.id, survivor_id: survivors[0].id }
      post '/api/v1/report_infection', params
      expect(last_response.status).to be(204)
    end

    it 'should not be able to report a survivor twice' do
      params = { infected_id: target.id, survivor_id: survivors[0].id }
      post '/api/v1/report_infection', params
      post '/api/v1/report_infection', params
      expect(last_response.status).to be(403)
    end

  end

  context '#show' do
    it 'should get a single survivor' do
      get "/api/v1/survivors/#{survivor.id}"
      expect(json['survivor']['name']).to eq(survivor.name)
    end
  end
end
