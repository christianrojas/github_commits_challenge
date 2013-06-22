class ReposController < ApplicationController
  respond_to :json

  def index
    respond_to do |format|
      format.html
      format.json { render json: Repo.all }
    end
  end

  def create
    respond_with Repo.create(params[:repo])
  end
end
