class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: :login_as

  def login_as
    return unless Rails.env.development?

    user = User.find params[:user_id]
    sign_in :user, user, byepass: true
    redirect_to after_sign_in_path_for(user)
  end
end
