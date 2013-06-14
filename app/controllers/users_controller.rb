class UsersController < ApplicationController
  include SessionsHelper
  include BCrypt
  def index
  end

  def create
    hNewRegistry=params[:user]
    sQuestionOneAnswer=Password.create("Lian Zhidao")
    sQuestionTwoAnswer=Password.create("Only you~~~")

    if sQuestionOneAnswer==hNewRegistry[:questionOne] && sQuestionTwoAnswer==hNewRegistry[:questionTwo]
      hNewRegistry.delete(:questionOne)
      hNewRegistry.delete(:questionTwo)
      @user=User.new(hNewRegistry)
      if @user.save
        memorizeUser(@user.username,@user.id)
        redirect_to @user
      else
        render 'new'
      end
    else
      render :text => "<h2>You didn't answer registry questions correctly!</h2>", :layout=>'layouts/application'
    end
  end

  def new
    @user=User.new
  end

  def edit
    @user=User.find(params[:id])
  end

  def editEmail
    user=User.find(useridForSignedInUser)
  end

  def updateEmail
    user=User.find(useridForSignedInUser)
    user.email=params[:user][:email]
    if user.save
      redirect_to edit_user_path(user)
    else
      redirect_to editEmail_path(user)
    end
  end

  def changePassword
    user=User.find(useridForSignedInUser)
  end

  def updatePassword
    user=User.find(useridForSignedInUser)
    if user.authenticate(params[:user][:old_password])
      puts "good"
      user.password=params[:user][:password]
      if user.save
        flash[:notice] = "Password Updated."
        redirect_to edit_user_path(user)
      else
        redirect_to changePassword_path(user)
      end
    else  
      flash[:notice] = "Wrong Password! Please try again."
      redirect_to changePassword_path(user)
    end
  end

  def show
    @user=User.find(params[:id])
  end

  def destroy
  end
end
