require 'rails_helper'

describe Api::V1::ReportsController, type: :api do

  describe "#index" do
    let(:survivors) { ["/reports/survivors/healthy", "/reports/survivors/infected"] }
    let(:items) do
      [ "/reports/items/water",
        "/reports/items/food",
        "/reports/items/medication",
        "/reports/items/ammo",
        "/reports/items/lost" ]
    end

    subject { get '/api/v1/reports' }
    it { expect(subject.status).to be(200) }
    it { expect(subject_json['reports']['items']).to eq(items) }
    it { expect(subject_json['reports']['survivors']).to eq(survivors) }
  end

end
