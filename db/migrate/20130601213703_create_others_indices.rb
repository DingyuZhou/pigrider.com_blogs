class CreateOthersIndices < ActiveRecord::Migration
  def change
    create_table :others_indices, :id=>false do |t|
      t.integer :blogID, :null => false, :limit=>11
      t.timestamps
    end
    add_index :others_indices, [:blogID], :unique => true
    add_index :others_indices, [:updated_at]
  end
end
