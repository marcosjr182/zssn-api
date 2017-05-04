require "rails_helper"

describe Api::V1::SurvivorsController, type: :api do
  let!(:survivor) { create(:survivor) }

  context '#create' do
    it 'should create a survivor' do
      survivor_params = {survivor: {name: 'Test'}}
      post '/api/v1/survivors', survivor_params
      expect(last_response.status).to be(201)
    end

    it 'should not create a survivor without a name' do
      survivor_params = {survivor: {gender: 'F', age: 10}}
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

    context "when it has a page parameter" do
      subject { get "/api/v1/survivors", { :page => 2 } }
      it { expect(subject.status). to eql(200) }
      it { expect(subject_json['survivors']).to be_empty }
    end
  end

  describe '#update' do
    let(:location) { { :lat => 5.5, :lng => 1.1 } }
    let(:params) { { survivor: location } }

    context 'when trying to update a location' do
      subject { patch "api/v1//survivors/#{survivor.id}", params }
      it { expect(subject.status).to be(200) }
    end

    context 'when trying to update something else' do
      subject { patch "api/v1//survivors/#{survivor.id}", { survivor: location.merge!(name: 'Test') } }
      it { expect(subject.status).to be(200) }
      it { expect(subject_json['survivor']['name']).to start_with("Survivor") }
    end
  end

  context '#show' do
    it 'should get a single survivor' do
      get "/api/v1/survivors/#{survivor.id}"
      expect(json['survivor']['name']).to eq(survivor.name)
    end
  end
end
