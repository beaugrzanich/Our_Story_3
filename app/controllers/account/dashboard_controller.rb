class Account::DashboardController < Account::ApplicationController
  def index
    redirect_to account_teams_path
  end
  def Home
    @micropost = current_user.microposts.build if logged_in?
  end
end
