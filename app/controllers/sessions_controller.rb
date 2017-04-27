class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        login user
        params[:session][:remember_me] == "1"? remember(user) : forget(user)
        redirect_back_friendly user
      else
        message = t("acc_not_activated") + t("check_email_for_validate_link")
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "danger_notification"
      render :new
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end
end
