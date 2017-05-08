class TradeService
  class InvalidTrade < StandardError; end

  def initialize(survivor, recipient, params)
    @survivor = survivor
    @survivor_offer  = params[:survivor][:offer]
    @recipient = recipient
    @recipient_offer = params[:recipient][:offer]
  end

  def process
    raise InvalidTrade.new(I18n.t('errors.services.trade.infected')) if @survivor.infected? or @recipient.infected?
    trade_items
    Inventory.transaction do
      @survivor.inventory.save!
      @recipient.inventory.save!
    end
  end

  private
  def check_balance(item_name)
    if @survivor_offer[item_name].to_i > @survivor.inventory[item_name] or
       @recipient_offer[item_name].to_i > @recipient.inventory[item_name]
      raise InvalidTrade.new(I18n.t('errors.services.trade.balance'))
    end
  end

  def trade_items
    offer_score = { survivor: 0, recipient: 0 }

    ITEMS.each do |item_name, item_score|
      check_balance(item_name)

      offer_score[:survivor]  += item_score * @survivor_offer[item_name].to_i
      offer_score[:recipient] += item_score * @recipient_offer[item_name].to_i

      balance = @survivor_offer[item_name].to_i - @recipient_offer[item_name].to_i

      unless balance.eql? 0
        @recipient.inventory[item_name] += balance
        @survivor.inventory[item_name]  -= balance
      end
    end

    unless offer_score[:survivor].eql? offer_score[:recipient]
      raise InvalidTrade.new(I18n.t('errors.services.trade.score'))
    end
  end
end
