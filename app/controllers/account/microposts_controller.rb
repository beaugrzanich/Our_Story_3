class Account::MicropostsController < Account::ApplicationController
  account_load_and_authorize_resource :micropost, through: :user, through_association: :microposts

  # GET /account/users/:user_id/microposts
  # GET /account/users/:user_id/microposts.json
  def index
    delegate_json_to_api
  end

  # GET /account/microposts/:id
  # GET /account/microposts/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/users/:user_id/microposts/new
  def new
    @micropost = current_user.microposts.build(micropost_params) 
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  # GET /account/microposts/:id/edit
  def edit
  end

  # POST /account/users/:user_id/microposts
  # POST /account/users/:user_id/microposts.json
  def create
    respond_to do |format|
      if @micropost.save
        format.html { redirect_to [:account, @user, :microposts], notice: I18n.t("microposts.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @micropost] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/microposts/:id
  # PATCH/PUT /account/microposts/:id.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to [:account, @micropost], notice: I18n.t("microposts.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @micropost] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/microposts/:id
  # DELETE /account/microposts/:id.json
  def destroy
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @user, :microposts], notice: I18n.t("microposts.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  include strong_parameters_from_api

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end

  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
