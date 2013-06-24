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
    respond_with Repo.create!(params.permit(:repo, :account))
  end

  def update
    respond_with Repo.update(params[:id], repo_params)
  end

  def destroy
    respond_with Repo.destroy(params[:id])
  end

private
  def repo_params
    params[:repo]
  end
end
