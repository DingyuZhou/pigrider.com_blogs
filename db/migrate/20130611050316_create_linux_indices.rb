class CreateLinuxIndices < ActiveRecord::Migration
  def change
    create_table :linux_indices do |t|
      t.integer :blogID, :null=>false, :limit=>11

      t.timestamps
    end
    add_index :linux_indices, [:blogID], :unique=>true
  end
end
