class BasketsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @baskets = current_user.baskets.custom_sort(sort_column, sort_direction).
    paginate(page: params[:page], per_page: 15) unless !current_user unless !current_user
  end

  def new
    redirect_to baskets_path unless current_user.id != 100
  end

  def show
    @basket = Basket.find(params[:id])
    if @basket.user != current_user
      redirect_to baskets_path,  flash: { alert: "You can only view your own baskets" }
    end
  end

  def create
    Basket.create_basket(current_user, params[:date])
    redirect_to baskets_path
  end

  def remove
    current_user.baskets.destroy_all
    redirect_to baskets_path
  end

  private

  def sort_column
    params[:sort]
  end

  def sort_direction
    ["asc", "desc"].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
