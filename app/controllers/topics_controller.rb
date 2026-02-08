class TopicsController < ApplicationController
  include SpamProtection

  before_action :require_authentication, except: :show
  before_action :check_honeypot!, only: :create
  before_action :check_rate_limit!, only: :create
  before_action :set_category
  before_action :set_topic, only: [:show, :edit, :update, :destroy, :lock, :pin]
  before_action :authorize_author!, only: [:edit, :update]
  before_action :authorize_destroy!, only: :destroy
  before_action :require_staff, only: [:lock, :pin]

  def show
    @posts = @topic.posts.order(:created_at).page(params[:page]).per(Post::PER_PAGE)
    @post = Post.new
  end

  def new
    @topic = @category.topics.new
  end

  def create
    @topic = @category.topics.new(topic_params)
    @topic.user = current_user
    if @topic.save
      redirect_to category_topic_path(@category, @topic), notice: "Topic created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      redirect_to category_topic_path(@category, @topic), notice: "Topic updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @topic.destroy
    redirect_to category_path(@category), notice: "Topic deleted."
  end

  def lock
    @topic.update!(locked: !@topic.locked?)
    status = @topic.locked? ? "locked" : "unlocked"
    redirect_to category_topic_path(@category, @topic), notice: "Topic #{status}."
  end

  def pin
    @topic.update!(pinned: !@topic.pinned?)
    status = @topic.pinned? ? "pinned" : "unpinned"
    redirect_to category_topic_path(@category, @topic), notice: "Topic #{status}."
  end

  private

  def set_category
    @category = Category.find_by!(slug: params[:category_slug])
  end

  def set_topic
    @topic = @category.topics.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :body)
  end

  def authorize_author!
    unless @topic.authored_by?(current_user)
      flash[:alert] = "Not authorized."
      redirect_to category_topic_path(@category, @topic)
    end
  end

  def authorize_destroy!
    unless @topic.authored_by?(current_user) || current_user&.staff?
      flash[:alert] = "Not authorized."
      redirect_to category_topic_path(@category, @topic)
    end
  end
end
