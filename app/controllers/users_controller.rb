class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      EmailCombination.new(user_params).generate_email
      render :create
    else
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :url, :email)
  end
end
