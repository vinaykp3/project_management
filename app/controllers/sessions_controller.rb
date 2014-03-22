class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "Welcome to the Sample App!"
      sign_in user
      redirect_to employees_path
    else
      flash[:danger] = "Invalid Email/Password Combination"
      redirect_to new_session_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
