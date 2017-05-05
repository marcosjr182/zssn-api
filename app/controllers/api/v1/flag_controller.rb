module Api::V1
  class FlagController < ApiController
    rescue_from FlagService::InvalidReport, :with => :invalid_report

    api :POST, '/flag/infected', 'Report a survivor as infected'
    param :infected_id, :number
    param :survivor_id, :number
    def infected
      return head 400 unless params[:survivor_id] and params[:infected_id]
      @infected = Survivor.find(params[:infected_id])
      @survivor = Survivor.find(params[:survivor_id])

      FlagService.process(@survivor, @infected)
      head 204
    end

    private
      def invalid_report(error)
        render json: { error: error.message }, status: 403
      end
  end
end
