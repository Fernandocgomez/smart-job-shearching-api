module ModelHelper

  def init_instance_with_default_value(model, params, attribute)
    model.new(params.except!(attribute))
  end

end
