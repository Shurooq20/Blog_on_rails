class CommentsController < ApplicationController
    def create 
        @post = Post.find(params[:post_id])
        @comment = Comment.new comment_params
        @comment.post = @post 
        # byebug
        @comment.user = current_user
        if @comment.save 
            redirect_to @post
        else 
            @comments = @post.comments.order(created_at: :desc)
            render 'posts/show'
        end
    end


    def destroy
        @comment = Comment.find params[:id]
        if can?(:crud, @comment)
            @comment.destroy 
            redirect_to @comment.post
            else 
            
            head :unauthorized
        end
    end


    private 

    def comment_params 
        params.require(:comment).permit(:body)
    end

end
