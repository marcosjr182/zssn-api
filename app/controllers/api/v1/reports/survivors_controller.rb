module Api::V1
  class Reports::SurvivorsController < ApiController
    api! 'Reports about survivors'
    def index
      response = [:infected, :healthy].map { |status| create_report(status) }
      render json: response, status: 200
    end

    api! 'Percentage of healthy survivors'
    def healthy
      render json: create_report(:healthy), status: 200
    end

    api! 'Percentage of infected survivors'
    def infected
      render json: create_report(:infected), status: 200
    end

    private
      def create_report(status)
        {
          :title => I18n.t("reports.survivors", status: status),
          :value => (Survivor.public_send(status).count.to_f / Survivor.all.count) * 100
        }
      end
  end
end
