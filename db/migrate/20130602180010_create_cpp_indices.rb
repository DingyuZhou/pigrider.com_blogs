class CreateCppIndices < ActiveRecord::Migration
  def change
    create_table :cpp_indices, :id=>false do |t|
      t.integer :blogID, :null => false, :limit=>11
      t.timestamps
    end
    add_index :cpp_indices, [:blogID], :unique => true
    add_index :cpp_indices, [:updated_at]
  end
end
