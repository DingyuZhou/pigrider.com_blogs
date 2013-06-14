module SessionsHelper
  def memorizeUser(username,id)
    session[:rememberedUsername]=username
    session[:rememberedUserid]=id
  end
  
  def signOutUser
    session.delete(:rememberedUsername)
  end
  
  def userSignedIn(username=nil)
    if username.nil?
      return !session[:rememberedUsername].nil?
    else
      return !session[:rememberedUsername].nil? && session[:rememberedUsername]==username
    end
  end
  
  def usernameForSignedInUser
    return session[:rememberedUsername]
  end
  
  def useridForSignedInUser
   return session[:rememberedUserid]
  end
end
