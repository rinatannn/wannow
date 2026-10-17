class Admin::BaseController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    unless Current.user&.admin?
      redirect_to root_path, alert: "管理者のみアクセスできます"
    end
  end
end
