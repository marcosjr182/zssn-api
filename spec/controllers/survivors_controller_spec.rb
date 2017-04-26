require "rails_helper"

describe SurvivorsController, :type => :api do
  let!(:survivor) { create(:survivor) }

  context '#create' do
    it 'should create a survivor' do
      survivor_params = {survivor: {name: 'Test'}}
      post '/survivors', survivor_params
      expect(last_response.status).to be(201)
    end

    it 'should not create a survivor without a name' do
      survivor_params = {survivor: {water: 0, food: 1, age: 10}}
      post '/survivors', survivor_params
      expect(last_response.status).to be(422)
    end
  end

  context '#index' do
    it "GET index" do
      get '/survivors'
      survivor = SurvivorSerializer.new(survivor)
      expect(last_response.status).to eql(200)
    end

    it "can take a page as parameter" do
      get "/survivors", { :page => 2 }
      expect(last_response.status).to eql(200)
      expect(json['survivors']).to be_empty
    end
  end

  context '#update' do
    it 'should update only the location for valid users' do
      params = {survivor: { name: 'Test', lat: 5.5, lng: 1.1 }}
      patch "/survivors/#{survivor.id}", params
      expect(last_response.status).to be(200)
      expect(json['survivor']['name']).to eq(survivor.name)
    end
  end

  context '#show' do
    it 'should get a single survivor' do
      get "/survivors/#{survivor.id}"
      expect(json['survivor']['name']).to eq(survivor.name)
    end
  end
end
