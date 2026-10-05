class HomesController < ApplicationController
  allow_unauthenticated_access only: %i[top about]

  def top
  end

  def about
  end

  def mypage
    @user = Current.user
  end
end