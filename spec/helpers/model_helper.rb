require_relative "params_helper"

module ModelHelper
  extend ParamsHelper

  # <----------- User --------------->

  def init_user_instance_with_default_value(attribute)
    params = ParamsHelper.get_user_params.clone
    params.except!(attribute)
    User.new(params)
  end

  # <----------- Company --------------->

  def init_company_instance_with_default_value(user_id, attribute)
    params = ParamsHelper.get_company_params.clone
    params["user_id"] = user_id
    params.except!(attribute)
    Company.new(params)
  end

  # <----------- Lead --------------->

  def init_lead_instance_with_default_value(column_id, company_id, attribute)
    params = ParamsHelper.get_lead_params.clone
    params["column_id"] = column_id
    params["company_id"] = company_id
    params.except!(attribute)
    Lead.new(params)
  end

  # <----------- JobPosition --------------->

  def init_job_position_instance_with_default_value(company_id, attribute)
    params = ParamsHelper.get_job_position_params.clone
    params["company_id"] = company_id
    params.except!(attribute)
    JobPosition.new(params)
  end

  # <----------- LeadEmail --------------->

  def init_lead_email_instance_with_default_value(lead_id, job_position_id, attribute)
    params = ParamsHelper.get_lead_email_params.clone
    params["lead_id"] = lead_id
    params["job_position_id"] = job_position_id
    params.except!(attribute)
    LeadEmail.new(params)
  end

end
