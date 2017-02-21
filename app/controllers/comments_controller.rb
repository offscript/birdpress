class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  
  def create 
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = "That's the Word!"
      redirect_to micropost_url
    else
      flash[:danger] = "Make sure you have a Title and Body!"
      render micropost_url
    end
  end
  
  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted!"
    redirect_to request.referrer || root_url
  end

  private 
  
  def comment_params
     params.require(:comment).permit(:body, :title)
  end
  
  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end
