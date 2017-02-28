class NickNameRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @nick_name_requests = NickNameRequest.where(status: 'unreviewed')
    else
      redirect_to root_path, flash: { alert: 'You do not have access to this page' }
    end
  end

  def create
  end

  def update
    @nick_name_request = NickNameRequest.find(params[:id])
    NickNameRequest.process_request(@nick_name_request, params)
    redirect_to nick_name_requests_path
  end

end