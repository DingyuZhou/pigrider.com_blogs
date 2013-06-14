class CreateRorIndices < ActiveRecord::Migration
  def change
    create_table :ror_indices do |t|
      t.integer :blogID, :null => false, :limit=>11

      t.timestamps
    end
    add_index :ror_indices, [:blogID], :unique => true
  end
end