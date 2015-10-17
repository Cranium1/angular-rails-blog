class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # # GET /posts
  # # GET /posts.json
  # def index
  #   @posts = Post.page

  #   render json: @posts, :except => [:html, :user_id, :public, :markdown]
  # end

  # GET /page/:page
  # GET /page/:page.json
  def page
    page = params[:page].to_i

    if Post.total_pages < page || page < 0
      render nothing: true, status: 404
    else
      @posts = Post.page(page)

      data = { 
        :posts => @posts,
        :pagination => {
          :page => page,
          :total_pages => Post.total_pages
        }
      }

      data[:pagination][:next_page] = page+1 if page < Post.total_pages
      data[:pagination][:prev_page] = page-1 if page > 1

      render json: data, :except => [:html, :user_id, :public, :markdown]
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    render json: @post
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      head :no_content
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy

    head :no_content
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      # params.require(:post).permit(:title, :html, :markdown, :public, :user_id)
    end
end
