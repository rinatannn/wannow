class PostsController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  def index
  @posts = Post.includes(:user).order(created_at: :desc)

  if params[:keyword].present?
    keyword = "%#{Post.sanitize_sql_like(params[:keyword])}%"
    @posts = @posts.where(
      "title LIKE :keyword OR body LIKE :keyword",
      keyword: keyword
    )
  end
end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Current.user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "投稿しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Current.user.posts.find(params[:id])
  end

  def update
    @post = Current.user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to @post, notice: "投稿を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Current.user.posts.find(params[:id])
    @post.destroy!

    redirect_to posts_path, notice: "投稿を削除しました。", status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
