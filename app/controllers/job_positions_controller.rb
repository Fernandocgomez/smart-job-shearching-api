class JobPositionsController < ApplicationController

  def create
    job_position = JobPosition.new(job_position_params)
    if job_position.valid?
      job_position.save
      render json: { "resp" => JobPositionSerializer.new(job_position) }, status: 201
    else
      render json: { "resp" => job_position.errors.messages }, status: 400
    end
  end

  def show
    job_position = JobPosition.find_by_id(params[:id])
    if job_position
      render json: { "resp" => JobPositionSerializer.new(job_position) }, status: 200
    else
      render json: { "resp" => "job position can't be found" }, status: 404
    end
  end

  def update
    job_position = JobPosition.find_by_id(params[:id])
    if job_position
      job_position.update(job_position_params)
      if job_position.valid?
        render json: { "resp" => JobPositionSerializer.new(job_position) }, status: 200
      else
        render json: { "resp" => job_position.errors.messages }, status: 400
      end
    else
      render json: { "resp" => "job position can't be found" }, status: 404
    end
  end

  def destroy
    job_position = JobPosition.find_by_id(params[:id])
    if job_position
      job_position.destroy
      render json: { "resp" => "job position has been deleted" }, stauts: 200
    else
      render json: { "resp" => "job position can't be found" }, status: 404
    end
  end

  private

  def job_position_params
    params.permit(
      :name,
      :description,
      :city,
      :state,
      :applied,
      :user_id,
      :company_id
    )
  end
end
