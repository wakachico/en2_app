class PostsController < ApplicationController
  before_action :set_category_list, only: [:index, :new, :select_category_index]

  def index
    @posts = Post.all.order("created_at DESC")
    @user = User.find(current_user.id)
  end

  def new
    @post = Post.new
    @category_parent_array = ["---"]
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end
  end

  def get_category_children
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find_by(id: "#{params[:children_id]}").children
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to root_path
    else
      render :index
    end
  end

  def edit
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user.id)
  end
  
  def select_category_index
    @category = Category.find_by(id: params[:id])
    if @category.ancestry == nil
      category = Category.find_by(id: params[:id]).indirect_ids
      @posts = []
      find_post(category)
      @message = "『 #{@category.name} 』の検索結果"
    elsif @category.ancestry.include?("/")
      @posts = Post.where(category_id: params[:id])
      @message = "『 #{@category.root.name} 』 > 『 #{@category.parent.name} 』 > 『 #{@category.name} 』の検索結果"
    else
      category = Category.find_by(id: params[:id]).child_ids
      @posts = []
      find_post(category)
      @message = "『 #{@category.root.name} 』 > 『 #{@category.name} 』の検索結果"
    end
    @user = User.find(current_user.id)
    render :index
  end

  private

  def find_post(category)
    category.each do |id|
      post_array = Post.includes(:user).where(category_id: id)
      if post_array.present?
        post_array.each do |post|
          if post.present?
            @posts.push(post)
          else
            
          end
        end
      end
    end
  end

  def post_params
    params.permit(:title, :text).merge(user_id: current_user.id, category_id: params[:grandchildren_id] )
  end
end

