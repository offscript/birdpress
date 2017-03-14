module UsersHelper
  
  #checks for an avatar
  def avatar?
    !current_user.avatar.nil?
  end
end
