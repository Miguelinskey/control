class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:position)
  end

  def show
    @category = Category.find_by!(slug: params[:slug])
    @topics = @category.topics.order(pinned: :desc, created_at: :desc).page(params[:page]).per(25)
  end
end
