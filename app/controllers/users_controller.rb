class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update, :account, :edit_account, :update_account]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "ユーザー登録が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = current_user
  end

  def account
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to account_users_path, notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit_account
    @user = current_user
  end

  def update_account
    @user = current_user
    if @user.authenticate(params[:current_password])
      if params[:user][:password].blank?
        @user.errors.add(:password, "を入力してください")
        render :edit_account, status: :unprocessable_entity
      elsif @user.update(account_params)
        redirect_to account_users_path, notice: "アカウント情報を更新しました"
      else
        render :edit_account, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "現在のパスワードが正しくありません"
      render :edit_account, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def profile_params
    params.require(:user).permit(:name, :bio, :icon_image)
  end

  def account_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end