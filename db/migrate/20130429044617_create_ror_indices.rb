class CreateRorIndices < ActiveRecord::Migration
  def change
    create_table :ror_indices, :id=>false do |t|
      t.integer :blogID, :null => false, :limit=>11
      t.timestamps
    end
    add_index :ror_indices, [:blogID], :unique => true
    add_index :ror_indices, [:updated_at]
  end
end