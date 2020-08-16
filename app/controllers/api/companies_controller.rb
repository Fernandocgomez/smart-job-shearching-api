class Api::CompaniesController < ApplicationController
  def create
    if is_user_authorized?(company_params)
      create_company(company_params)
    else
      render json: { "resp" => "you can not create a company that is not associated with your user without being an admin" }, status: 401
    end
  end

  def show
    company = Company.find_by_id(params[:id])
    if company
      if is_user_authorized?(company)
        render json: { "resp" => CompanySerializer.new(company) }, status: 200
      else
        render json: { "resp" => "you can not access to other users' company without being an admin" }, status: 401
      end
    else
      render json: { "resp" => "company can't be found" }, status: 404
    end
  end

  def update
    company = Company.find_by_id(params[:id])
    if company
      if is_user_authorized?(company)
        update_company(company)
      else
        render json: { "resp" => "you can not update a company that is not associated with your user without being an admin" }, status: 401
      end
    else
      render json: { "resp" => "company can't be found" }, status: 404
    end
  end

  def destroy
    company = Company.find_by_id(params[:id])
    if company
      if is_user_authorized?(company)
        destroy_company(company)
      else
        render json: { "resp" => "you can not delete a company that is not associated with your user without being an admin" }, status: 401
      end
    else
      render json: { "resp" => "company can't be found" }, status: 404
    end
  end

  private

  def is_user_authorized?(obj)
    obj["user_id"].to_i == decoded_token[0]["user_id"]
  end

  def create_company(params)
    company = Company.new(params)
    if company.valid?
      company.save
      render json: { "resp" => CompanySerializer.new(company) }, status: 201
    else
      render json: { "resp" => company.errors.messages }, status: 400
    end
  end

  def update_company(company)
    company.update(company_params)
    if company.valid?
      render json: { "resp" => CompanySerializer.new(company) }, status: 200
    else
      render json: { "resp" => company.errors.messages }, status: 400
    end
  end

  def destroy_company(company)
    company.destroy
    render json: { "resp" => "company has been deleted" }, status: 200
  end
  
  def company_params
    params.permit(
      :name,
      :linkedin_url,
      :website,
      :about,
      :user_id
    )
  end
end
