class ShoutsController < ApplicationController
  before_action :set_shout, only: [:destroy, :show, :update]
  before_action :set_user
  before_action :authenticate_user!, :except [:show, :index]
  before_action :redirect_unless_user_match, :except [:show, :index]

  def index
    @shouts = @user.shouts.all
  end

  def new
    @shout = Shout.new
    render :new
  end

  def create
    @shout = Shout.new(shout_params)
    @shout.user_id = params[:user_id]
    @shout.save
    redirect_to user_shouts_path
  end

  def destroy
    @shout.destroy
    redirect_to :action => :index, notice: 'Shout destroyed.  Boo yah!'
  end

  def show
    @shout = Shout.find(params[:id])
    render :show
  end

  def update
    @shout.update(shout_params)
    @shout.save
    redirect_user users_shouts_path(@user, @shouts)
  end


  private

    def shout_params
      params.require(:shout).permit(:body, :user_id)
    end

    def set_shout
      @shout = Shout.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def redirect_unless_user_match
      unless @user == current_user
        flash[:notice] = "You cannot perform actions on #{@user.username}"
        redirect_to :root
      end
    end

end
