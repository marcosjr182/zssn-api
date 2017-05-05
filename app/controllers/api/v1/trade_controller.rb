module Api::V1
  class TradeController < ApiController
    rescue_from TradeService::InvalidTrade, :with => :invalid_trade
    before_action :trade_params
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

    api :POST, '/trade', 'Trade items'
    param_group :trade_apipie
    def index
      TradeService.new(@survivor, @recipient, params).process
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

      def invalid_trade(error)
        render json: { error: error.message }, status: 403
      end
  end
end
