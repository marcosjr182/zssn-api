module Api::V1
  class Reports::ItemsController < ApiController
    before_action :set_survivors

    api!
    def index
      response = [:water, :food, :medication, :ammo].map { |item| average_report(item) }
      render json: response, status: 200
    end

    api!
    def water
      render json: average_report(:water), status: 200
    end

    api!
    def food
      render json: average_report(:food), status: 200
    end

    api!
    def medication
      render json: average_report(:medication), status: 200
    end

    api!
    def ammo
      render json: average_report(:ammo), status: 200
    end

    api!
    def lost
      render json: lost_score_report, status: 200
    end

    private

      def report(title, value)
        { :title => title, :value => value }
      end

      def lost_score
        Survivor.infected.map do |survivor|
          ITEMS.map { |key, value| ITEMS[key] * survivor[key] }.sum
        end.sum
      end

      def lost_score_report
        title = I18n.t('reports.lost_points')
        report(title, lost_score)
      end

      def average_report(item)
        title = I18n.t('reports.items', item: item)
        value = @survivors.map(&item.to_sym).sum / @survivors.count
        report(title, value)
      end

      def set_survivors
        @survivors = Survivor.healthy
      end
  end
end
