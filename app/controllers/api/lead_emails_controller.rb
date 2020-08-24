class Api::LeadEmailsController < ApplicationController
  before_action :check_user_access, only: [:create]

  def create
    lead_email = LeadEmail.new(lead_email_params)
    if lead_email.valid?
      lead_email.save
      render json: { "resp" => LeadEmailSerializer.new(lead_email) }, status: 201
    else
      render json: { "resp" => lead_email.errors.messages }, status: 400
    end
  end

  def show
    lead_email = LeadEmail.find_by_id(params[:id])
    if lead_email
      render json: { "resp" => LeadEmailSerializer.new(lead_email) }, status: 200
    else
      render json: { "resp" => "lead email can't be found" }, status: 404
    end
  end

  def update
    lead_email = LeadEmail.find_by_id(params[:id])
    if lead_email
      lead_email.update(lead_email_params)
      if lead_email.valid?
        render json: { "resp" => LeadEmailSerializer.new(lead_email) }, status: 200
      else
        render json: { "resp" => lead_email.errors.messages }, status: 400
      end
    else
      render json: { "resp" => "lead email can't be found" }, status: 404
    end
  end

  def destroy
    lead_email = LeadEmail.find_by_id(params[:id])
    if lead_email
      lead_email.destroy
      render json: { "resp" => "lead email has been deleted" }, status: 200
    else
      render json: { "resp" => "lead email can't be found" }, status: 404
    end
  end

  private

  def user_auth?(user_id)
    user_id == decoded_token[0]["user_id"]
  end

  def unauthorized_error_message(action)
    render json: {"resp" => "you can not #{action} a lead_email that is not associated with one of yours job_postions or leads without being an admin"}, status: 401
  end

  def check_user_access
    lead_email = JobPosition.find_by_id(params[:id])
    case params["action"]
    when "create"
      record_owner_id = JobPosition.find_by_id(lead_email_params["job_position_id"].to_i).company.user.id
      unauthorized_error_message("create") unless user_auth?(record_owner_id)
    else
      nil
    end
  end

  def lead_email_params
    params.permit(
      :email,
      :subject,
      :email_body,
      :sent,
      :open,
      :lead_id,
      :job_position_id
    )
  end
end
