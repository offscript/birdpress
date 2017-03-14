class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  
  
  def new
    @micropost = Micropost.new
  end

  def show 
    @micropost = Micropost.find_by(params[:id])
    @comment = current_user.comments.build(micropost_id: @micropost.id) #new comments
   #@comments = Comment.where(micropost_id: @micropost.id) no sql lite in production
    @comments = Comment.where("micropost_id = ?", params[:id])
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to micropost_path(@micropost)
    else
      flash[:alert] = "Something went wrong"
      @feed_items = [ ]
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end
  
  def edit
    @micropost = Micropost.find_by(params[:id])
  end
  
  def update
    if @micropost.update_attributes(micropost_params)
      flash[:success] = "Post updated"
      redirect_to micropost_path(@micropost)
    else
      render 'edit'
    end
  end
  
  private

    def micropost_params
      params.require(:micropost).permit(:content, :title, :picture)
    end
  
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
