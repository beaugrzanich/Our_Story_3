class Api::V1::MicropostsController < Api::V1::ApplicationController
  account_load_and_authorize_resource :micropost, through: :user, through_association: :microposts

  # GET /api/v1/users/:user_id/microposts
  def index
  end

  # GET /api/v1/microposts/:id
  def show
  end

  # POST /api/v1/users/:user_id/microposts
  def create
    if @micropost.save
      render :show, status: :created, location: [:api, :v1, @micropost]
    else
      render json: @micropost.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/microposts/:id
  def update
    if @micropost.update(micropost_params)
      render :show
    else
      render json: @micropost.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/microposts/:id
  def destroy
    @micropost.destroy
  end

  private

  module StrongParameters
    # Only allow a list of trusted parameters through.
    def micropost_params
      strong_params = params.require(:micropost).permit(
        *permitted_fields,
        :content,
        :body,
        # 🚅 super scaffolding will insert new fields above this line.
        *permitted_arrays,
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      process_params(strong_params)

      strong_params
    end
  end

  include StrongParameters
end
