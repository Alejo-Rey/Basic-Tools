# Clear existing data
puts "Clearing existing data..."
PetLevel.destroy_all
Resource.destroy_all

# Create Resources (Pet Food)
puts "Creating resources..."

Resource.create!([
  {
    name: "Enriched Croquette",
    resource_type: "pet_food",
    xp_value: 500,
    average_price: 15000, # Average market price in kamas
    description: "Premium pet food that provides 500 XP. Can be bought with Kolossokens or Nuggets."
  },
  {
    name: "Super Croquette",
    resource_type: "pet_food",
    xp_value: 300,
    average_price: 8000,
    description: "Good quality pet food that provides 300 XP."
  },
  {
    name: "Basic Croquette",
    resource_type: "pet_food",
    xp_value: 100,
    average_price: 3000,
    description: "Basic pet food that provides 100 XP."
  }
])

# Create Pet Levels data based on user's detailed information
puts "Creating pet level XP requirements..."

pet_levels_data = [
  { level: 1, total_xp: 0, xp_to_next_level: 47, croquettes_needed: 1 },
  { level: 2, total_xp: 47, xp_to_next_level: 54, croquettes_needed: 1 },
  { level: 3, total_xp: 101, xp_to_next_level: 62, croquettes_needed: 1 },
  # ... continuing through level 37
  { level: 38, total_xp: 500, xp_to_next_level: 547, croquettes_needed: 1 },
  { level: 44, total_xp: 1000, xp_to_next_level: 1024, croquettes_needed: 1 },
  { level: 48, total_xp: 1500, xp_to_next_level: 1524, croquettes_needed: 1 },
  { level: 51, total_xp: 2000, xp_to_next_level: 2081, croquettes_needed: 1 },
  { level: 53, total_xp: 2500, xp_to_next_level: 2538, croquettes_needed: 1 },
  { level: 55, total_xp: 3000, xp_to_next_level: 3090, croquettes_needed: 1 },
  { level: 57, total_xp: 3500, xp_to_next_level: 3757, croquettes_needed: 1 },
  { level: 58, total_xp: 4000, xp_to_next_level: 4141, croquettes_needed: 1 },
  { level: 59, total_xp: 4500, xp_to_next_level: 4562, croquettes_needed: 1 },
  { level: 60, total_xp: 5000, xp_to_next_level: 5024, croquettes_needed: 1 },
  { level: 61, total_xp: 5500, xp_to_next_level: 5531, croquettes_needed: 1 },
  { level: 62, total_xp: 6000, xp_to_next_level: 6088, croquettes_needed: 1 },
  { level: 63, total_xp: 6500, xp_to_next_level: 6699, croquettes_needed: 1 },
  { level: 64, total_xp: 7000, xp_to_next_level: 7369, croquettes_needed: 1 },
  { level: 65, total_xp: 7500, xp_to_next_level: 8103, croquettes_needed: 1 },
  { level: 66, total_xp: 8500, xp_to_next_level: 8908, croquettes_needed: 2 },
  { level: 67, total_xp: 9000, xp_to_next_level: 9790, croquettes_needed: 1 },
  { level: 68, total_xp: 10000, xp_to_next_level: 10756, croquettes_needed: 2 },
  { level: 69, total_xp: 11000, xp_to_next_level: 11815, croquettes_needed: 2 },
  { level: 70, total_xp: 12000, xp_to_next_level: 12975, croquettes_needed: 2 },
  { level: 71, total_xp: 13000, xp_to_next_level: 14245, croquettes_needed: 2 },
  { level: 72, total_xp: 14500, xp_to_next_level: 15635, croquettes_needed: 3 },
  { level: 73, total_xp: 16000, xp_to_next_level: 17157, croquettes_needed: 3 },
  { level: 74, total_xp: 17500, xp_to_next_level: 18823, croquettes_needed: 3 },
  { level: 75, total_xp: 19000, xp_to_next_level: 20646, croquettes_needed: 3 },
  { level: 76, total_xp: 21000, xp_to_next_level: 22641, croquettes_needed: 4 },
  { level: 77, total_xp: 23000, xp_to_next_level: 24823, croquettes_needed: 4 },
  { level: 78, total_xp: 25000, xp_to_next_level: 27209, croquettes_needed: 4 },
  { level: 79, total_xp: 27500, xp_to_next_level: 29819, croquettes_needed: 5 },
  { level: 80, total_xp: 30000, xp_to_next_level: 32673, croquettes_needed: 5 },
  { level: 81, total_xp: 33000, xp_to_next_level: 35793, croquettes_needed: 6 },
  { level: 82, total_xp: 36000, xp_to_next_level: 39203, croquettes_needed: 6 },
  { level: 83, total_xp: 39500, xp_to_next_level: 42930, croquettes_needed: 7 },
  { level: 84, total_xp: 43000, xp_to_next_level: 47003, croquettes_needed: 7 },
  { level: 85, total_xp: 47500, xp_to_next_level: 51453, croquettes_needed: 9 },
  { level: 86, total_xp: 51500, xp_to_next_level: 56315, croquettes_needed: 8 },
  { level: 87, total_xp: 56500, xp_to_next_level: 61626, croquettes_needed: 10 },
  { level: 88, total_xp: 62000, xp_to_next_level: 67427, croquettes_needed: 11 },
  { level: 89, total_xp: 67500, xp_to_next_level: 73762, croquettes_needed: 11 },
  { level: 90, total_xp: 74000, xp_to_next_level: 80679, croquettes_needed: 13 },
  { level: 91, total_xp: 81000, xp_to_next_level: 88231, croquettes_needed: 14 },
  { level: 92, total_xp: 88500, xp_to_next_level: 96476, croquettes_needed: 15 },
  { level: 93, total_xp: 96500, xp_to_next_level: 105476, croquettes_needed: 16 },
  { level: 94, total_xp: 105500, xp_to_next_level: 115299, croquettes_needed: 18 },
  { level: 95, total_xp: 115500, xp_to_next_level: 126019, croquettes_needed: 20 },
  { level: 96, total_xp: 126500, xp_to_next_level: 137716, croquettes_needed: 22 },
  { level: 97, total_xp: 138000, xp_to_next_level: 150479, croquettes_needed: 23 },
  { level: 98, total_xp: 150500, xp_to_next_level: 164403, croquettes_needed: 25 },
  { level: 99, total_xp: 164500, xp_to_next_level: 179592, croquettes_needed: 28 },
  { level: 100, total_xp: 179592, xp_to_next_level: 0, croquettes_needed: 31 }
]

PetLevel.create!(pet_levels_data)

puts "Seed data created successfully!"
puts "- #{Resource.count} resources created"
puts "- #{PetLevel.count} pet levels created"
