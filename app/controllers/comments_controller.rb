class CommentsController < ApplicationController
  before_action :reject_guest, only: %i[create destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = Current.user

    if @comment.save
      redirect_to @post, notice: "コメントを投稿しました。"
    else
      redirect_to @post, alert: "コメントを入力してください。"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.where(user: Current.user).find(params[:id])
    @comment.destroy!

    redirect_to @post, notice: "コメントを削除しました。", status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def reject_guest
    if Current.user.guest?
      redirect_to posts_path, alert: "ゲストユーザーはコメントを投稿・削除できません。"
    end
  end
end
