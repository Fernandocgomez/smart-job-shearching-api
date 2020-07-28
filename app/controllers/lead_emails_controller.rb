class LeadEmailsController < ApplicationController
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
