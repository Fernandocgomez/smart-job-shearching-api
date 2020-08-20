class Api::JobPositionsController < ApplicationController

  def create
    user_id = Company.find_by_id(job_position_params["company_id"].to_i).user.id
    if user_auth?(user_id)
      create_job_position(job_position_params)
    else
      unauthorized_error_message("create")
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

  def user_auth?(user_id)
    user_id == decoded_token[0]["user_id"]
  end

  def create_job_position(params)
    job_position = JobPosition.new(params)
    if job_position.valid?
      job_position.save
      render json: { "resp" => JobPositionSerializer.new(job_position) }, status: 201
    else
      render json: { "resp" => job_position.errors.messages }, status: 400
    end
  end

  def unauthorized_error_message(action)
    render json: {"resp" => "you can not #{action} a job position that is not associated with one of yours companies without being an admin"}, status: 401
  end

  def job_position_params
    params.permit(
      :name,
      :description,
      :city,
      :state,
      :applied,
      :company_id
    )
  end
end
