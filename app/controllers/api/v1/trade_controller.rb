module Api::V1
  class TradeController < ApiController
    before_action :set_traders, only: [:index]

    def_param_group :trade_apipie do
      param :survivor, Hash, :required => true, :desc => 'Survivor' do
        param :id, :number, :required => true
        param :offer, Hash, :required => true do
          param_group :items_apipie, SurvivorsController
        end
      end
      param :recipient, Hash, :required => true, :desc => 'Trade Recipient' do
        param :id, :number, :required => true
        param :offer, Hash, :required => true do
          param_group :items_apipie, SurvivorsController
        end
      end
    end

    api :POST, '/trade'
    param_group :trade_apipie
    def index
      unless @survivor and @recipient
        return render json: { error: 'Invalid Traders' }, status: 403
      end

      if @survivor.infected? or @recipient.infected?
        return render json: { error: 'Infected survivors are not allowed to trade' }, status: 403
      end

      survivor_offer  = params[:survivor][:offer]
      recipient_offer = params[:recipient][:offer]

      offer_score = { survivor: 0, recipient: 0 }

      ITEMS.each do |item, item_score|
        offer_score[:survivor]  += item_score * survivor_offer[item].to_i
        offer_score[:recipient] += item_score * recipient_offer[item].to_i

        balance = survivor_offer[item].to_i - recipient_offer[item].to_i
        if balance.positive?
          @recipient[item] -= balance
          @survivor[item]  += balance
        elsif balance.negative?
          @recipient[item] += balance
          @survivor[item]  -= balance
        end
      end

      if offer_score[:survivor].eql? offer_score[:recipient]
        @survivor.save!
        @recipient.save!
      else
        return render json: { error: 'Trade offers do not have the same score' }, status: 403
      end

      head 204
    end

    private
      def set_traders
        @survivor  = Survivor.find(params[:survivor][:id])
        @recipient = Survivor.find(params[:recipient][:id])
      end

      def trade_params
        params.require(:survivor).permit(:id, :offer => [:water, :food, :medication, :ammo])
        params.require(:recipient).permit(:id, :offer => [:water, :food, :medication, :ammo])
      end
  end
end
