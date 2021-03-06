class UsersController < ApplicationController
  before_action :authenticate_user!

  def following
    @title = "Following:"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers:"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def show
    @user = User.includes(:posts).find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end
end
