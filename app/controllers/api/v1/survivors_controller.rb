module Api::V1
  class SurvivorsController < ApiController
    before_action :set_survivor, only: [:show, :update, :destroy]

    def_param_group :location do
      param :lat, Float, 'Latitude'
      param :lng, Float, 'Longitude'
    end

    def_param_group :items do
      param :water, :number, 'Water'
      param :food, :number, 'Food'
      param :medication, :number, 'Medication'
      param :ammo, :number, 'Ammunition'
    end

    def_param_group :survivor do
      param :id, :number
      param :name, String
      param :age, :number
      param_group :location
      param_group :items
    end

    api :GET, '/survivors'
    def index
      survivors = Survivor.page(params[:page]).per(12)
      render json: survivors, meta: {pagination: {per_page: 12}}
    end

    api :GET, '/survivors/:id'
    param :id, :number
    def show
      render json: @survivor
    end

    api :POST, '/survivors'
    param_group :survivor, required: true
    def create
      @survivor = Survivor.new(survivor_params)

      if @survivor.save
        render json: @survivor, status: :created
      else
        render json: @survivor.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/survivors/:id'
    api :PUT, '/survivors/:id'
    param :id, :number, required: true
    def update
      @survivor = Survivor.find(params[:id])
      if @survivor.update(location_params)
        render json: @survivor, status: :ok
      else
        render json: @survivor.errors, status: :unprocessable_entity
      end
    end

    # DELETE /survivors/1
    api :DELETE, '/survivors/:id'
    param :id, :number, required: true
    def destroy
      @survivor.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_survivor
        @survivor = Survivor.find(params[:id])
      end

      def location_params
        params.require(:survivor).permit(:lat, :lng)
      end

      # Only allow a trusted parameter "white list" through.
      def survivor_params
        params.require(:survivor).permit(:name, :age, :gender, :lat, :lng, :water, :food, :medication, :ammo, :infected, :age)
      end
  end
end
