class ApplicationController < ActionController::Base
  protect_from_forgery
  layout '../pigrider_layout/main/globalLayout'
  helper PigriderUser::SessionsHelper
end
