class CreateLinuxIndices < ActiveRecord::Migration
  def change
    create_table :linux_indices, :id=>false do |t|
      t.integer :blogID, :null => false, :limit=>11
      t.timestamps
    end
    add_index :linux_indices, [:blogID], :unique=>true
    add_index :linux_indices, [:updated_at]
  end
end
