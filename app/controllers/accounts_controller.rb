class AccountsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @user = User.new
  end

  def create
    if User.exists?(email_address: user_params[:email_address])
      redirect_to new_session_path, alert: "Account already exists"
      return
    end

    @user = User.create_with_defaults(user_params)
    if @user.persisted?
      redirect_to root_path, notice: "Account created"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
