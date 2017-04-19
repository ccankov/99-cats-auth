class CatsController < ApplicationController
  before_action :check_cat_ownership, only: [:edit, :update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params.merge(owner_id: current_user.id))
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def check_cat_ownership
    @cat = current_user.cats.find_by(id: params[:id])
    unless @cat
      flash[:errors] = ["This cat does not belong to #{current_user.user_name}"]
      redirect_back fallback_location: cats_url
    end
  end

  def cat_params
    params.require(:cat)
          .permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
