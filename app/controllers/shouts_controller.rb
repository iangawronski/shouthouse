class ShoutsController < ApplicationController
  before_action :set_shout [:show, :edit, :destroy]

  def index
    @shouts = @shouts.all
  end

  def new
    @shout = Shout.new
    render :new
  end

  def create
    @shout = Shout.new(shout_params)
    @shout.user_id = params[:user_id]
    redirect_to :action => :show
  end

  def destroy
    @shout.destroy
    redirect_to :action => :index, notice: 'Shout destroyed.  Boo yah!'
  end

  def show
    @shout = Shout.find(params[:id])
    render :show
  end


  private

    def shout_params
      params.require(:shout).permit(:body, :user_id)
    end

    def set_shout
      @shout = Shout.find(params[:id])
    end

end
