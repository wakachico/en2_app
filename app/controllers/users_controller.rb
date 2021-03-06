class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[show favorite_posts_show]
  before_action :set_category_list, only: %i[show favorite_posts_show]
  before_action :set_users_content, only: %i[show favorite_posts_show]

  def show
    @posts = @user.posts.order('created_at DESC').page(params[:page]).per(10)
    @message = "#{@user.nickname}さんの投稿一覧"
  end

  def favorite_posts_show
    @posts = @user.favorite_words.order('created_at DESC').page(params[:page]).per(10)
    @message = 'お気に入り投稿一覧'
    render :show
  end

  private

  def set_users_content
    @user = User.find(params[:id])
    @favorite_posts = @user.favorite_words.order('created_at DESC').limit(5)
    @favorite_users = []
    @favorite_posts.each do |favo_post|
      @favorite_users.push(favo_post.user) if favo_post.user.id != @user.id
    end
    @favorite_users = @favorite_users.uniq
  end

  def user_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
  end
end
