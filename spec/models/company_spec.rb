require "rails_helper"

RSpec.describe Company, type: :model do
  subject { create_company }

  describe "Validations" do
    describe "name" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.name = nil
        expect(subject).to_not be_valid
      end
    end
    describe "linkedin_url" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.linkedin_url = nil
        expect(subject).to_not be_valid
      end
    end
    describe "website" do
      it "must have a default value" do
        params = get_company_params
        params.except!("website")
        company = Company.create(params)
        expect(company).to be_valid
        expect(company["website"]).to eql("wwww.companyxwy.com")
      end
    end
    describe "about" do
      it "must have a default value" do
        params = get_company_params
        params.except!("about")
        company = Company.create(params)
        expect(company).to be_valid
        expect(company["about"]).to eql("about the company")
      end
    end
  end
end
