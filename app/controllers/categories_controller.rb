class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by!(slug: params[:slug])
    @topics = @category.topics.order(created_at: :desc).page(params[:page]).per(25)
  end
end
