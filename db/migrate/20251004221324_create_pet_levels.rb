class CreatePetLevels < ActiveRecord::Migration[8.0]
  def change
    create_table :pet_levels do |t|
      t.integer :level
      t.integer :total_xp
      t.integer :xp_to_next_level
      t.integer :croquettes_needed

      t.timestamps
    end
  end
end
