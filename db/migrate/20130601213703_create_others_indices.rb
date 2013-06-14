class CreateOthersIndices < ActiveRecord::Migration
  def change
    create_table :others_indices do |t|
      t.integer :blogID, :null => false, :limit=>11

      t.timestamps
    end
    add_index :others_indices, [:blogID], :unique => true
  end
end
