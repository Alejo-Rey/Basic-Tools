# Service class for calculating pet experience requirements
#
# This service calculates the total experience, croquettes, and kamas needed
# to level up a pet from a current level to a target level.
#
# @example Basic usage
#   service = PetExperienceService.new(1, 100)
#   result = service.calculate
#   # => { success: true, total_xp_needed: 179592, croquettes_needed: 360, ... }
#
# @example With specific resource
#   service = PetExperienceService.new(50, 75, resource_id: 2)
#   result = service.calculate
class PetExperienceService
  # Initialize the service with level range and optional resource
  #
  # @param current_level [Integer] The pet's current level (1-99)
  # @param target_level [Integer] The desired target level (2-100)
  # @param resource_id [Integer, nil] Optional ID of the resource to use (defaults to Enriched Croquette)
  # @param resource_price [Integer, nil] Optional custom price for the resource (overrides average_price)
  def initialize(current_level, target_level, resource_id = nil, resource_price = nil)
    @current_level = current_level
    @target_level = target_level
    @resource = resource_id ? Resource.find(resource_id) : Resource.find_by(name: "Enriched Croquette")
    @resource_price = resource_price || @resource.average_price
  end

  # Calculate all pet leveling requirements
  #
  # @return [Hash] Result hash containing:
  #   - success [Boolean] Whether the calculation was successful
  #   - total_xp_needed [Integer] Total XP required
  #   - croquettes_needed [Integer] Total croquettes required
  #   - total_cost [Decimal] Total cost in kamas
  #   - resource [Resource] The resource used for calculation
  #   - level_breakdown [Array<Hash>] Detailed breakdown per level
  #   - error [String] Error message (only if success is false)
  def calculate
    return error_result if @current_level >= @target_level

    {
      success: true,
      total_xp_needed: total_xp_needed,
      croquettes_needed: croquettes_needed,
      total_cost: total_cost,
      resource: @resource,
      level_breakdown: level_breakdown
    }
  end

  private

  # Calculate total XP needed from current level to target level
  #
  # Uses the difference between target level's total XP and current level's total XP
  #
  # @return [Integer] Total XP required
  def total_xp_needed
    target_level_data = PetLevel.find_by(level: @target_level)
    current_level_data = PetLevel.find_by(level: @current_level)

    return 0 unless target_level_data && current_level_data

    target_level_data.total_xp - current_level_data.total_xp
  end

  # Calculate total number of croquettes needed
  #
  # Sums up the croquettes_needed field for all levels in the range.
  # This uses pre-calculated data based on actual game mechanics where
  # croquettes needed varies by level (1 croquette for lower levels,
  # up to 31 croquettes for level 99->100).
  #
  # @return [Integer] Total number of croquettes required
  def croquettes_needed
    levels = PetLevel.where("level > ? AND level <= ?", @current_level, @target_level)
    levels.sum(:croquettes_needed)
  end

  # Calculate total cost in kamas
  #
  # Multiplies total croquettes by the resource price (custom or average market price)
  #
  # @return [Integer] Total cost in kamas
  def total_cost
    croquettes_needed * @resource_price
  end

  # Generate detailed breakdown of requirements per level
  #
  # Provides a level-by-level analysis showing XP, croquettes, and cost
  # for each level in the range
  #
  # @return [Array<Hash>] Array of hashes, one per level, containing:
  #   - level [Integer] The level number
  #   - total_xp [Integer] Cumulative XP at this level
  #   - xp_to_next [Integer] XP needed to reach next level
  #   - croquettes [Integer] Croquettes needed for this level
  #   - cost [Integer] Cost in kamas for this level
  def level_breakdown
    levels = PetLevel.where("level > ? AND level <= ?", @current_level, @target_level).order(:level)

    levels.map do |level|
      {
        level: level.level,
        total_xp: level.total_xp,
        xp_to_next: level.xp_to_next_level,
        croquettes: level.croquettes_needed,
        cost: level.croquettes_needed * @resource_price
      }
    end
  end

  # Generate error result when validation fails
  #
  # @return [Hash] Error result with success: false and error message
  def error_result
    {
      success: false,
      error: "Target level must be higher than current level"
    }
  end
end
