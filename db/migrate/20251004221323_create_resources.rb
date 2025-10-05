class CreateResources < ActiveRecord::Migration[8.0]
  def change
    create_table :resources do |t|
      t.string :name
      t.string :resource_type
      t.integer :xp_value
      t.integer :average_price
      t.text :description

      t.timestamps
    end
  end
end
