require "rails_helper"

describe Api::V1::SurvivorsController, type: :api do
  let!(:survivor)  { create(:survivor) }
  let!(:survivors) { create_list(:survivor, 10) }

  describe '#create' do
    context 'with valid params' do
      let!(:survivor_params) { {survivor: {name: 'Test'}} }
      subject { post '/api/v1/survivors', survivor_params }
      it { expect(subject.status).to be(201) }
    end

    context 'with no name' do
      let!(:survivor_params) { {survivor: {gender: 'F', age: 10}} }
      subject { post '/api/v1/survivors', survivor_params }
      it { expect(subject.status).to be(422) }
    end
  end

  describe '#index' do
    context "with no parameters" do
      let!(:serialized) { SurvivorSerializer.new(survivors) }
      subject { get '/api/v1/survivors' }
      it { expect(subject.status).to eql(200) }
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

  describe '#show' do
    context 'with a valid survivor id' do
      subject { get "/api/v1/survivors/#{survivor.id}" }
      it { expect(subject.status).to be(200) }
      it { expect(subject_json['survivor']['name']).to eq(survivor.name) }
    end

    context 'with an invalid survivor id' do
      subject { get "/api/v1/survivors/#{9999999}" }
      it { expect(subject.status).to be(403) }
      it { expect(subject_json['error']).to start_with("Couldn't find Survivor") }
    end
  end
end
