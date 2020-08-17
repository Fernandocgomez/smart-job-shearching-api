class Api::LeadsController < ApplicationController
  def create
    column_id = lead_params["column_id"].to_i
    column = Column.find_by_id(column_id)
    user_id = column ? column.board.user.id : nil
    if user_auth?(user_id)
      updated_params = set_default_position(column, lead_params)
      create_lead(updated_params)
    else
      unauthorized_error_message("create")
    end
  end

  def show
    lead = Lead.find_by_id(params[:id])
    if lead
      user_id = lead.column.board.user.id
      if user_auth?(user_id)
        render json: {"resp" => LeadSerializer.new(lead)}, status: 200
      else
        unauthorized_error_message("access")
      end
    else
      not_found_error_message
    end
  end

  def update
    lead = Lead.find_by_id(params[:id])
    if lead 
      user_id = lead.column.board.user.id
      if user_auth?(user_id)
        if lead_params.include?("position")
          if lead_has_same_position(lead, lead_params) && lead_params.keys.size == 1
            render json: {"resp" => "lead has the same position value"}, status: 400
          else
            if lead_has_same_position(lead, lead_params)
              update_lead(lead_params, lead)
            else 
              update_position(lead, lead_params)
            end
          end
        else
          update_lead(lead_params, lead)
        end
      else
        unauthorized_error_message("update")
      end
    else 
      not_found_error_message
    end
  end

  def destroy
    lead = Lead.find_by_id(params[:id])
    if lead
      user_id = lead.column.board.user.id
    if user_auth?(user_id)
        destroy_lead(lead)
      else
        unauthorized_error_message("delete")
      end
    else
      not_found_error_message
    end
  end

  private

  def user_auth?(user_id)
    user_id == decoded_token[0]["user_id"]
  end

  def create_lead(params)
    lead = Lead.new(params)
    if lead.valid? 
      lead.save
      render json: {"resp" => LeadSerializer.new(lead)}, status: 201
    else 
      render json: {"resp" => lead.errors.messages}, status: 400
    end
  end

  def update_lead(params, lead)
    lead.update(lead_params)
    if lead.valid?
      render json: {"resp" => LeadSerializer.new(lead)}, status: 200
    else 
      render json: {"resp" => lead.errors.messages}, status: 400
    end
  end

  def destroy_lead(lead)
    lead.destroy
    render json: {"resp" => "lead has been deleted"}, status: 200
  end

  def unauthorized_error_message(action)
    render json: {"resp" => "you can not #{action} a lead that is not associated with one of yours columns without being an admin"}, status: 401
  end

  def not_found_error_message
    render json: {"resp" => "lead can't be found"}, status: 404
  end

  def set_default_position(column, params)
    updated_params = params
    number_of_leads = column.leads.count
    updated_params["position"] = number_of_leads
    updated_params
  end

  def update_position(lead, params)
    old_position = lead.position
    new_position = params["position"].to_i
    leads_associated = lead.column.leads
    if old_position > new_position
      leads_associated.each do |record|
        if record.position.between?(new_position, old_position)
          if record.id == lead.id
            record.update(params)
          else
            record.update(position: record.position + 1)
          end
        end
      end
    else
      leads_associated.each do |record|
        if record.position.between?(old_position, new_position)
          if record.id == lead.id
            record.update(params)
          else
            record.update(position: record.position - 1)
          end
        end
      end
    end
    updated_lead = Lead.find_by_id(lead.id)
    render json: {"resp" => LeadSerializer.new(updated_lead)}, status: 200
  end

  def lead_has_same_position(lead, params)
    lead.position == params["position"].to_i
  end

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
    :position,
    :column_id,
    :company_id
    )
  end
end
