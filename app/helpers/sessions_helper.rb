module SessionsHelper
  def memorizeUser(sUsername,iUserid)
    session[:rememberedUsername]=sUsername
    session[:rememberedUserid]=iUserid
  end
  
  def signOutUser
    session.delete(:rememberedUsername)
    session.delete(:rememberedUserid)
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
