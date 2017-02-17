class PasswordResetsController < ApplicationController
 before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] #if the expiration date
  #is expired we send them back to the password reset form, see method
  
  def new
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty? #if the password is empty
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params) #successful reset go ahaed
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit' #if the reset was not successful the password was invalid
    end
  end
  
  def create 
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash[:danger] = "Invalid Email Address"
      render 'new'
    end
  end 
  
  
  private #all before_actions seem to be private
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  def get_user
      @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user.
  def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
  end
  
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
  
end
