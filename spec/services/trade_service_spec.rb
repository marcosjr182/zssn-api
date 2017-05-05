require 'rails_helper'

describe TradeService, type: :service do
  let!(:survivor)  { create(:survivor) }
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

  end

end
