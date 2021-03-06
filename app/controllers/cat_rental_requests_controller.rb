class CatRentalRequestsController < ApplicationController
  before_action :check_cat_ownership, only: [:approve, :deny]

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    full_params = cat_rental_request_params.merge(requester_id: current_user.id)
    @rental_request = CatRentalRequest.new(full_params)
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  def new
    @rental_request = CatRentalRequest.new
  end

  private

  def check_cat_ownership
    unless current_cat.owner == current_user
      flash[:errors] = ["Cannot manage requests for other people's cats."]
      redirect_back fallback_location: cats_url
    end
  end

  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request)
      .permit(:cat_id, :end_date, :start_date, :status)
  end
end
