class LeadsController < ApplicationController
  def create
    lead = Lead.new(lead_params)
    if lead.valid? 
      lead.save
      render json: {"resp" => LeadSerializer.new(lead)}, status: 201
    else 
      render json: {"resp" => lead.errors.messages}, status: 400
    end
  end

  def show
    lead = Lead.find_by_id(params[:id])
    if lead 
      render json: {"resp" => LeadSerializer.new(lead)}, status: 200
    else
      render json: {"resp" => "lead can't be found"}, status: 404
    end
  end

  def update
    lead = Lead.find_by_id(params[:id])
    if lead 
      lead.update(lead_params)
      if lead.valid?
        render json: {"resp" => LeadSerializer.new(lead)}, status: 200
      else 
        render json: {"resp" => lead.errors.messages}, status: 400
      end
    else 
      render json: {"resp" => "lead can't be found"}, status: 404
    end
  end

  def destroy
    lead = Lead.find_by_id(params[:id])
    if lead 
      lead.destroy
      render json: {"resp" => "lead has been deleted"}, status: 200
    else
      render json: {"resp" => "lead can't be found"}, status: 404
    end
  end

  private

  def lead_params
    params.permit(
    :first_name,
    :last_name,
    :picture_url, 
    :linkedin_url, 
    :status, 
    :notes, 
    :email,
    :phone_number, 
    :column_id,
    :company_id
    )
  end
end
