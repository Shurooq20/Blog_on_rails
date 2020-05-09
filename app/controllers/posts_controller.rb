class PostsController < ApplicationController


    before_action :authenticate_user!, except: [:index, :show]

    before_action :authorize!, only: [:edit, :update, :destroy]

    def index
        @posts = Post.all.order('updated_at DESC')
    end

    def new 

        @post = Post.new

    end

    def create 
        post_params = params.require(:post).permit(:title, :body)
        @post = Post.new post_params
        @post.user = current_user
        if @post.save 
            redirect_to @post
        else
            render :new 
        end
    end

    def edit 
        @post = Post.find params[:id]
    end

    def update
        post_params = params.require(:post).permit(:title, :body)
        @post = Post.find params[:id]
        if @post.update post_params
            redirect_to @post
        else
            render :edit
        end
    end

    def show
        @post = Post.find params[:id]
        @comment = Comment.new
        @comments = @post.comments.order(created_at: :DESC)
    end

    def index
        @post = Post.order(created_at: :DESC)
    end

    def destroy
        @post = Post.find(params[:id])
        @post.destroy
        redirect_to posts_path
    end

    def authorize! 
        redirect_to root_path, alert: 'Not Authorized' unless can?(:crud, Post)
    end
end
