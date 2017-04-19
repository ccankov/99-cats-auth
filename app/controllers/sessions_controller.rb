class SessionsController < ApplicationController
  before_action :logged_in, only: [:new, :create]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(user_params[:user_name],
                                    user_params[:password])

    if user
      login(user)
      redirect_to cats_url
    else
      flash[:errors] = 'Invalid username or password.'
      redirect_to new_session_url
    end
  end

  def destroy
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
    redirect_to cats_url
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
