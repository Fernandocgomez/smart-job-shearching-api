class Api::JobPositionsController < ApplicationController

  before_action :check_user_privileges, only: [:create, :show, :update, :destroy]

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
    render json: { "resp" => JobPositionSerializer.new(job_position) }, status: 200
  end

  def update
    job_position = JobPosition.find_by_id(params[:id])   
    job_position.update(job_position_params)
    if job_position.valid?
      render json: { "resp" => JobPositionSerializer.new(job_position) }, status: 200
    else
      render json: { "resp" => job_position.errors.messages }, status: 400
    end
  end

  def destroy
    job_position = JobPosition.find_by_id(params[:id])
    job_position.destroy
    render json: { "resp" => "job position has been deleted" }, stauts: 200
  end 

  private

  def user_auth?(user_id)
    user_id == decoded_token[0]["user_id"]
  end

  def unauthorized_error_message(action)
    render json: {"resp" => "you can not #{action} a job position that is not associated with one of yours companies without being an admin"}, status: 401
  end

  def not_found_error_message
    render json: { "resp" => "job position can't be found" }, status: 404
  end

  def check_user_privileges
    job_position = JobPosition.find_by_id(params[:id])
    case params["action"]
    when "create"
      record_owner_id = Company.find_by_id(job_position_params["company_id"].to_i).user.id
      unauthorized_error_message("create") unless user_auth?(record_owner_id)
    when "show"
      if job_position
        record_owner_id = job_position.company.user.id
        unauthorized_error_message("access") unless user_auth?(record_owner_id)
      else
        not_found_error_message
      end
    when "update"
      if job_position
        record_owner_id = job_position.company.user.id
        unauthorized_error_message("update") unless user_auth?(record_owner_id)
      else
        not_found_error_message
      end
    when "destroy"
      if job_position
        record_owner_id = job_position.company.user.id
        unauthorized_error_message("delete") unless user_auth?(record_owner_id)
      else
        not_found_error_message
      end
    else
      nil
    end
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
