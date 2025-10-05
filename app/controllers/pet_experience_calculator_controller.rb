class PetExperienceCalculatorController < ApplicationController
  def index
    @resources = Resource.all
    @resource_prices = @resources.each_with_object({}) { |r, h| h[r.id.to_s] = r.average_price }
    @calculation_result = nil

    if params[:current_level].present? && params[:target_level].present?
      current_level = params[:current_level].to_i
      target_level = params[:target_level].to_i
      resource_id = params[:resource_id]
      resource_price = params[:resource_price]&.to_i

      service = PetExperienceService.new(current_level, target_level, resource_id, resource_price)
      @calculation_result = service.calculate
    end
  end

  def update_resource_price
    resource = Resource.find(params[:id])
    new_price = params[:price].to_i

    if resource.update(average_price: new_price)
      render json: { success: true, message: I18n.t('tools.pet_calculator.price_updated'), price: new_price }
    else
      render json: { success: false, message: I18n.t('tools.pet_calculator.price_update_failed') }, status: :unprocessable_entity
    end
  end
end