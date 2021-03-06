class BasketsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :my_user, only: %i[index show]

  def index
    return unless @my_user && !my_user.baskets.empty?
    all_baskets = my_user.baskets
    default_start = all_baskets.order(:transaction_date).first.transaction_date
    @spending_state = SpendingState.new(default_start, params)
    @graph_config = @spending_state.set_graph
    @baskets = all_baskets.from_graph(@graph_config)
                       .custom_sort(@spending_state.sort_column, @spending_state.sort_direction)
                       .page params[:page]
  end

  def show
    @basket = Basket.find(params[:id])
    return if @basket.user == @my_user
    redirect_to baskets_path, flash: { alert: 'You can only view your own baskets' }
  end

  def destroy_all
    current_user.baskets.destroy_all
    redirect_to baskets_path, flash: { alert: 'Your purchase history has been removed' }
  end
end
