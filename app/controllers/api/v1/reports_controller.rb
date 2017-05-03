module Api::V1
  class ReportsController < ApiController
    api! 'List available reports'
    def index
      response = { reports: { items: items, survivors: survivors } }
      render json: response, status: 200
    end

    private
      def items
        [ "/reports/items/water",
          "/reports/items/food",
          "/reports/items/medication",
          "/reports/items/ammo",
          "/reports/items/lost" ]
      end

      def survivors
        [ "/reports/survivors/healthy",
          "/reports/survivors/infected" ]
      end
  end
end
