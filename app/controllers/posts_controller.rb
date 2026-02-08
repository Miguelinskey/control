class PostsController < ApplicationController
  before_action :require_authentication
  before_action :set_category_and_topic
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :authorize_author!, only: [:edit, :update]
  before_action :authorize_destroy!, only: :destroy
  before_action :check_locked!, only: :create

  def create
    @post = @topic.posts.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to category_topic_path(@category, @topic), notice: "Reply posted."
    else
      @posts = @topic.posts.order(:created_at).page(params[:page]).per(25)
      render "topics/show", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to category_topic_path(@category, @topic), notice: "Reply updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to category_topic_path(@category, @topic), notice: "Reply deleted."
  end

  private

  def set_category_and_topic
    @category = Category.find_by!(slug: params[:category_slug])
    @topic = @category.topics.find(params[:topic_id])
  end

  def set_post
    @post = @topic.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body)
  end

  def check_locked!
    if @topic.locked?
      flash[:alert] = "This topic is locked."
      redirect_to category_topic_path(@category, @topic)
    end
  end

  def authorize_author!
    unless @post.authored_by?(current_user)
      flash[:alert] = "Not authorized."
      redirect_to category_topic_path(@category, @topic)
    end
  end

  def authorize_destroy!
    unless @post.authored_by?(current_user) || current_user&.admin?
      flash[:alert] = "Not authorized."
      redirect_to category_topic_path(@category, @topic)
    end
  end
end
