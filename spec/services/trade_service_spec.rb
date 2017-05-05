require 'rails_helper'

describe TradeService, type: :service do
  let!(:survivor)  { create(:survivor) }
  let!(:infected)  { create(:survivor, infected: true) }
  let!(:recipient) { create(:survivor) }
  let(:offer_items) { { water: 0, food: 0, medication: 0, ammo: 0 } }
  let(:trade_params) do
    {
      survivor:  { id: survivor.id, offer: offer_items.merge(medication: 2) },
      recipient: { id: recipient.id, offer: offer_items.merge(water: 1) }
    }
  end

  describe ".process" do
    context "when a trade is valid" do
      subject! { TradeService.new(survivor, recipient, trade_params).process }
      it { expect(survivor.inventory.reload[:medication]).to eq(1) }
      it { expect(survivor.inventory.reload[:water]).to eq(2) }
      it { expect(recipient.inventory.reload[:medication]).to eq(5) }
      it { expect(recipient.inventory.reload[:water]).to eq(0) }
    end

    context "when a trade has an invalid score" do
      let!(:invalid_score_params) { trade_params.merge(survivor: { id: survivor.id, offer: offer_items.merge(ammo: 1) }) }
      subject { TradeService.new(survivor, recipient, invalid_score_params) }
      it { expect { subject.process }.to raise_error(TradeService::InvalidTrade) }
    end

    context "when a trader has not enough items to trade" do
      let!(:invalid_balance_params) { trade_params.merge(survivor: { id: survivor.id, offer: offer_items.merge(ammo: 10) }) }
      subject { TradeService.new(survivor, recipient, invalid_balance_params) }
      it { expect { subject.process }.to raise_error(TradeService::InvalidTrade) }
    end

    context 'when a trader is infected' do
      let(:infected_params) { trade_params.merge(survivor: { id: infected.id, offer: offer_items.merge(medication: 2) }) }
      subject { TradeService.new(survivor, infected, infected_params) }
      it { expect { subject.process }.to raise_error(TradeService::InvalidTrade) }
    end
  end
end
