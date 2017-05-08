module Api::V1
  class SurvivorsController < ApiController
    before_action :set_survivor, only: [:show, :update, :destroy]

    def_param_group :location_apipie do
      param :survivor, Hash, :required => true do
        param :lat, :undef, 'Latitude', :required => true
        param :lng, :undef, 'Longitude', :required => true
      end
    end

    def_param_group :items_apipie do
      param :inventory_attributes, Hash do
        param :water, :number, 'Water'
        param :food, :number, 'Food'
        param :medication, :number, 'Medication'
        param :ammo, :number, 'Ammunition'
      end
    end

    def_param_group :survivor_apipie do
      param :survivor, Hash, :required => true do
        param :name, String
        param :age, :number
        param :lat, :undef, 'Latitude'
        param :lng, :undef, 'Longitude'
        param_group :items_apipie
      end
    end

    api :GET, '/survivors', 'List survivors'
    param :page, :number
    def index
      survivors = Survivor.page(params[:page]).per(12)
      render json: survivors, meta: { pagination: { per_page: 12 } }
    end

    api :GET, '/survivors/:id', 'Get a single survivor'
    param :id, :number
    def show
      render json: @survivor
    end

    api :POST, '/survivors', 'Create a new survivor'
    param_group :survivor_apipie
    def create
      @survivor = Survivor.new(survivor_params)
      if @survivor.save
        render json: @survivor, status: :created
      else
        render json: @survivor.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/survivors/:id', 'Update survivor location'
    api :PUT, '/survivors/:id', 'Update survivor location'
    param_group :location_apipie
    param :id, :number, required: true
    def update
      @survivor = Survivor.find(params[:id])
      @survivor.update(location_params)
      render json: @survivor, status: :ok
    end

    private
    def set_survivor
      @survivor = Survivor.find(params[:id])
    end

    def location_params
      params.require(:survivor).permit(:lat, :lng)
    end

    # Only allow a trusted parameter "white list" through.
    def survivor_params
      params.require(:survivor)
        .permit(:name, :age, :gender, :lat, :lng, :infected,
                :inventory_attributes => [:water, :food, :medication, :ammo])
    end
  end
end
