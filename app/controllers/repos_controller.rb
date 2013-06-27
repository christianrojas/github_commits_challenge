class ReposController < ApplicationController
  respond_to :json

  def index
    respond_to do |format|
      format.html
      format.json { render json: Repo.all }
    end
  end

  def show
    respond_with Repo.find(params[:id])
  end

  def create
    respond_with Repo.create(repo_params)
  end

private
  def repo_params
    params.permit(:repo, :account, :chain_obj_notation)
  end
end
