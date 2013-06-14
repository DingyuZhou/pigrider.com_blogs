class SessionsController < ApplicationController
  include SessionsHelper
  
  
  def new
  end
  
  def create
    user=User.find_by_username(params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      memorizeUser(user.username, user.id)
      redirect_to user
    else
      render 'new'
    end
  end

  def destroy
    signOutUser
    redirect_to root_url
  end
end
