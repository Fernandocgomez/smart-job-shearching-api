class CompaniesController < ApplicationController
  def create
    company = Company.new(company_params)
    if company.valid?
      company.save
      render json: {'resp' => CompanySerializer.new(company)}, status: 201
    else 
      render json: {'resp' => company.errors.messages}, status: 400
    end
  end

  def show
    company = Company.find_by_id(params[:id])
    if company 
      render json: {'resp' => CompanySerializer.new(company)}, status: 200
    else 
      render json: {'resp' => "company can't be found"}, status: 404
    end
  end

  def update
    company = Company.find_by_id(params[:id])
    if company
      company.update(company_params)
      if company.valid? 
        render json: {'resp' => CompanySerializer.new(company)}, status: 200
      else
        render json: {'resp' => company.errors.messages}, status: 400
      end
    else
      render json: {'resp' => "company can't be found"}, status: 404
    end
  end

  def destroy
    company = Company.find_by_id(params[:id])
    if company 
      company.destroy
      render json: {"resp" => "company has been deleted"}, status: 200
    else
      render json: {'resp' => "company can't be found"}, status: 404
    end
  end

  private

  def company_params
    params.permit(
      :name, 
      :linkedin_url, 
      :website, 
      :about
    )
  end
end
