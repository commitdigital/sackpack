class AccountsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @user = User.new
  end

  def create
    if (@user = User.create_with_defaults(user_params))
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
