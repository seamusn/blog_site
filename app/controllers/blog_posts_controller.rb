class BlogPostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_blog_post, except: [:new, :index, :create, :show]
  def index
    @pagy, @blog_posts = pagy(user_signed_in? ? BlogPost.all.sorted : BlogPost.published.sorted)
  end

  def show
    @blog_post = if user_signed_in?
                   BlogPost.find(params[:id])
                 else
                   BlogPost.published.find(params[:id])
                 end
  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post = BlogPost.new(blog_post_params)
    if @blog_post.save
      redirect_to @blog_post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @blog_post.update(blog_post_params)
      redirect_to @blog_post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog_post.destroy

    redirect_to root_path
  end

  private
  def blog_post_params
    params.require(:blog_post).permit(:title, :content, :published_at)
  end

  def set_blog_post
    @blog_post = BlogPost.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end