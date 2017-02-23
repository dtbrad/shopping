class ShoppingListsController < ApplicationController

  def index
    @shopping_lists = current_user.shopping_lists
    render json: @shopping_lists
  end

  def create
    @shopping_list = current_user.shopping_lists.build(shopping_list_params)
    if @shopping_list.save
      render json: @shopping_list, status: 201
    else
      @shopping_lists = ShoppingList.all
      render :index
    end
  end

  private

  def shopping_list_params
    params.require(:shopping_list).permit(
      :name, items_attributes: [:id, :name, :quantity, :price]
    )
  end

end
