require_relative 'params_helper'
module ModelHelper
  extend ParamsHelper

  # <----------- Global --------------->

  def check_default_value(model, params, attribute)
    model.new(params.except!(attribute))
  end

  # <----------- User --------------->

  @@user_params = ParamsHelper.get_user_params

  def create_user
    User.create(@@user_params)
  end

  def create_user_without_validations
    User.create!(@@user_params)
  end

  # <----------- Board --------------->

  @@board_params = ParamsHelper.get_board_params

  # def get_board_params(user_id)
  #   params = @@board_params.clone
  #   params['user_id'] = user_id
  #   params
  # end

  # def get_board_invalid_params
  #   params = @@board_params.clone
  #   params
  # end

  # def create_board(user_id)
  #   params = @@board_params.clone
  #   params['user_id'] = user_id
  #   Board.create(params)
  # end

  # <----------- Column --------------->

  @@column_params = ParamsHelper.get_column_params

  def get_column_params(board_id)
    params = @@column_params.clone
    params['board_id'] = board_id
    params
  end

  def get_invalid_column_params(board_id, invalid_param)
    params = @@column_params.clone
    params['name'] = invalid_param
    params['board_id'] = board_id
    params
  end

  def create_column(board_id)
    params = @@column_params.clone
    params['board_id'] = board_id
    Column.create(params)
  end

  # <----------- Company ---------------->

  @@company_params = ParamsHelper.get_company_params

  def create_company
    Company.create(@@company_params)
  end

  def get_company_params
    params = @@company_params.clone
    params
  end

  def get_invalid_cpmpany_params 
    params = @@company_params.clone
    params['name'] = nil
    params
  end

  def get_company_matcher(company_id)
    params = @@company_params.clone
    params['id'] = company_id
    params
  end

  # <----------- Lead ---------------->

  @@lead_params = ParamsHelper.get_lead_params

  def create_lead(column_id, company_id)
    params = @@lead_params.clone
    params['column_id'] = column_id
    params['company_id'] = company_id
    Lead.create(params)
  end

  def get_lead_params(column_id, company_id)
    params = @@lead_params.clone
    params['column_id'] = column_id
    params['company_id'] = company_id
    params
  end

  def get_invalid_lead_params(column_id, company_id)
    params = @@lead_params.clone
    params['column_id'] = column_id
    params['company_id'] = company_id
    params['first_name'] = nil
    params
  end

  def get_lead_matcher(column_id, company_id)
    params = @@lead_params.clone
    params['id'] = nil
    params['column_id'] = column_id
    params['company_id'] = company_id
    params
  end


  # <----------- JobPosition ---------------->

  @@job_position_params = ParamsHelper.get_job_position_params

  def create_job_position(user_id, company_id)
    params = @@job_position_params.clone
    params['user_id'] = user_id
    params['company_id'] = company_id
    JobPosition.create(params)
  end

  def get_job_position_params(user_id, company_id)
    params = @@job_position_params.clone
    params['user_id'] = user_id
    params['company_id'] = company_id
    params
  end

  def get_job_position_invalid_params(user_id, company_id, invalid_state)
    params = @@job_position_params.clone
    params['user_id'] = user_id
    params['company_id'] = company_id
    params['state'] = invalid_state
    params
  end

  def get_job_position_matcher(user_id, company_id, job_position_id)
    params = @@job_position_params.clone
    params['user_id'] = user_id
    params['company_id'] = company_id
    params['user_id'] = user_id
    params['id'] = job_position_id
    params
  end

  # <----------- LeadEmail ---------------->

  @@lead_email_params = ParamsHelper.get_lead_email_params

  def create_lead_email(lead_id, job_position_id)
    params = @@lead_email_params.clone
    params['lead_id'] = lead_id
    params['job_position_id'] = job_position_id
    LeadEmail.create(params)
  end

  def get_lead_email_params(lead_id, job_position_id)
    params = @@lead_email_params.clone
    params['lead_id'] = lead_id
    params['job_position_id'] = job_position_id
    params
  end

  def get_lead_email_invalid_params(lead_id, job_position_id)
    params = @@lead_email_params.clone
    params['lead_id'] = lead_id
    params['job_position_id'] = job_position_id
    params["email"] = "example@examplecom" 
    params
  end

  def get_lead_email_matcher(lead_id, job_position_id, lead_email_id)
    params = @@lead_email_params.clone
    params['lead_id'] = lead_id
    params['job_position_id'] = job_position_id
    params['id'] = lead_email_id
    params
  end

  def lead_email_check_default_value(get_params, value)
    params = get_params.except!(value)
    LeadEmail.create(params)
  end

end
