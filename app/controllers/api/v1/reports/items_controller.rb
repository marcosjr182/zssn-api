module Api::V1
  class Reports::ItemsController < ApiController
    before_action :set_survivors, except: [:lost]

    api! 'Items average reports'
    def index
      response = [:water, :food, :medication, :ammo].map { |item| average_report(item) }
      render json: response, status: 200
    end

    api! 'Average water quantity per survivor'
    def water
      render json: average_report(:water), status: 200
    end

    api! 'Average food quantity per survivor'
    def food
      render json: average_report(:food), status: 200
    end

    api! 'Average medication quantity per survivor'
    def medication
      render json: average_report(:medication), status: 200
    end

    api! 'Average ammunition per survivor'
    def ammo
      render json: average_report(:ammo), status: 200
    end

    api! 'Points lost due to infection'
    def lost
      render json: lost_score_report, status: 200
    end

    private
    def report(title, value)
      { :title => title, :value => value }
    end

    def lost_score
      Survivor.infected.map do |survivor|
        ITEMS.map { |key, value| value * survivor.inventory[key] }.sum
      end.sum
    end

    def lost_score_report
      title = I18n.t('reports.lost_points')
      report(title, lost_score)
    end

    def average_report(item)
      title = I18n.t('reports.items', item: item)
      value = @survivors.map { |s| s.inventory[item] }.sum / @survivors.count
      report(title, value)
    end

    def set_survivors
      @survivors = Survivor.healthy
    end
  end
end
