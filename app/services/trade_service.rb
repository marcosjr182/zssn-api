class TradeService
  class InvalidTrade < StandardError; end

  def initialize(survivor, recipient, params)
    @survivor = survivor
    @survivor_offer  = params[:survivor][:offer]
    @recipient = recipient
    @recipient_offer = params[:recipient][:offer]
  end

  def process
    raise InvalidTrade.new('Infected survivors cannot trade') if @survivor.infected? or @recipient.infected?
    if trade_items
      puts trade_items
      Survivor.transaction do
        @survivor.save!
        @recipient.save!
      end
    end
  end

  private
    def trade_items
      offer_score = { survivor: 0, recipient: 0 }

      ITEMS.each do |item_name, item_score|
        offer_score[:survivor]  += item_score * @survivor_offer[item_name].to_i
        offer_score[:recipient] += item_score * @recipient_offer[item_name].to_i

        balance = @survivor_offer[item_name].to_i - @recipient_offer[item_name].to_i
        if balance.positive?
          @recipient[item_name] -= balance
          @survivor[item_name]  += balance
        elsif balance.negative?
          @recipient[item_name] += balance
          @survivor[item_name]  -= balance
        end
      end

      unless offer_score[:survivor].eql? offer_score[:recipient]
        raise InvalidTrade.new('Trade offers do not have the same score')
      end
    end

end
