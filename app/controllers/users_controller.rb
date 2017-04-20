class UsersController < ApplicationController
  before_action :logged_in

  def new
    render :new
  end

  def create
    user = User.new(user_params)
    if user.save_plus_session
      login(user)
      msg = UserMailer.welcome_email(user)
      msg.deliver_now
      redirect_to cats_url
    else
      flash[:errors] = user.errors.full_messages
      redirect_to new_user_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
