require 'rails_helper'

describe Api::V1::Reports::SurvivorsController, type: :api do

  let!(:survivors) { create_list(:survivor, 3) }
  let!(:infected) { create(:survivor, infected: true) }

  describe "#index" do
    subject { get "/api/v1/reports/survivors" }
    it { expect(subject.status).to be(200) }
    it { expect(subject_json.length).to eq(2) }
  end

  describe "#healthy" do
    let(:title) { I18n.t('reports.survivors', status: 'healthy') }
    subject { get "/api/v1/reports/survivors/healthy" }
    it { expect(subject.status).to be(200) }
    it { expect(subject_json['title']).to eq(title) }
    it { expect(subject_json['value']).to eq(75) }
  end

  describe "#infected" do
    let(:title) { I18n.t('reports.survivors', status: 'infected') }
    subject { get "/api/v1/reports/survivors/infected" }
    it { expect(subject.status).to be(200) }
    it { expect(subject_json['title']).to eq(title) }
    it { expect(subject_json['value']).to eq(25) }
  end

end
