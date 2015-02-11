class UsersController < ApplicationController
  # before_action :authenticate_user!, :only => [:destroy]

  def new
   @user = User.new
   render :new
  end

  def create
    @user = User.create(user_params)
    redirect_to new_user_session
  end

  def index
    @users = User.all
    render :index
  end

  def destroy
    @user = User.find(params[:id])
    if current_user && (current_user.admin? || current_user == @user)
      @user.destroy
      redirect_to users_path, notice: "User deleted."
    else
      flash[:alert] = "You can only delete your own account!"
      redirect_to :root
    end
  end

private
  def user_params
    params.require(:user).permit(:username, :password, :email)
  end

end
