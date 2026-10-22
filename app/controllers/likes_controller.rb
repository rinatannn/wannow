class LikesController < ApplicationController
  before_action :reject_guest

  def create
    @post = Post.find(params[:post_id])
    Current.user.likes.find_or_create_by(post: @post)

    redirect_back fallback_location: post_path(@post), notice: "いいねしました。"
  end

  def destroy
    @post = Post.find(params[:post_id])
    like = Current.user.likes.find_by(post: @post)

    like&.destroy!

    redirect_back fallback_location: post_path(@post), notice: "いいねを解除しました。"
  end

  private

  def reject_guest
    if Current.user.guest?
      redirect_to posts_path, alert: "ゲストユーザーはいいねできません。"
    end
  end
end
