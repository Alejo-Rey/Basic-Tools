class PetExperienceCalculatorController < ApplicationController
  def index
    @resources = Resource.all
    @calculation_result = nil

    if params[:current_level].present? && params[:target_level].present?
      current_level = params[:current_level].to_i
      target_level = params[:target_level].to_i
      resource_id = params[:resource_id]
      resource_price = params[:resource_price]&.to_f

      service = PetExperienceService.new(current_level, target_level, resource_id, resource_price)
      @calculation_result = service.calculate
    end
  end
end