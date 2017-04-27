require 'rails_helper'

RSpec.describe Api::V1::TradeController, type: :api do
  let!(:infected) { create(:survivor, infected: true) }
  let!(:survivor) { create(:survivor) }
  let!(:trader)   { create(:survivor, :with_items) }

  describe "#index" do
    let(:offer_items) { { water: 0, food: 0, medication: 0, ammo: 0 } }
    let(:trade_params) do
      {
        survivor:  { id: survivor.id, offer: offer_items.merge(medication: 2) },
        recipient: { id: trader.id, offer: offer_items.merge(water: 1) }
      }
    end

    context 'when trade is valid' do
      subject { post '/api/v1/trade', trade_params }
      it { expect(subject.status).to be(204) }
    end

    context 'when trade offers have different scores' do
      let(:invalid_score_params) { trade_params.merge(survivor: { id: survivor.id, offer: offer_items }) }
      subject { post '/api/v1/trade', invalid_score_params }
      it { expect(subject.status).to be(403) }
    end

    context 'when a trader is infected' do
      let(:infected_trade_params) { trade_params.merge(survivor: { id: infected.id, offer: offer_items.merge(medication: 2) }) }
      subject { post '/api/v1/trade', infected_trade_params }
      it { expect(subject.status).to be(403) }
    end

  end
end
