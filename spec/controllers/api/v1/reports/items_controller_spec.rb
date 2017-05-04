require 'rails_helper'

describe Api::V1::Reports::ItemsController, type: :api do
  let!(:survivors) { create_list(:survivor, 4, :with_items) }

  describe "#index" do
    subject { get "/api/v1/reports/items" }
    it { expect(subject.status).to be(200) }
  end

  [:water, :food, :medication, :ammo].each.with_index(1) do |item, i|
    describe "##{item}" do
      let(:title) { I18n.t('reports.items', item: item) }
      subject { get "/api/v1/reports/items/#{item}" }
      it { expect(subject.status).to be(200) }
      it { expect(subject_json['title']).to eq(title) }
      it { expect(subject_json['value']).to eq(i) }
    end
  end

  describe "#lost" do
    let!(:infected) { create(:survivor, :with_items, infected: true) }
    let(:title) { I18n.t('reports.lost_points') }
    subject { get "/api/v1/reports/items/lost" }
    it { expect(subject.status).to be(200) }
    it { expect(subject_json['title']).to eq(title) }
    it { expect(subject_json['value']).to eq(20) }
  end

end
