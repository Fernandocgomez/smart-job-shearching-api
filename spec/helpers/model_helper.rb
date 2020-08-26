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

end
