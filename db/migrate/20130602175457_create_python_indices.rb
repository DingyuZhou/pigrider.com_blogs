class CreatePythonIndices < ActiveRecord::Migration
  def change
    create_table :python_indices, :id=>false do |t|
      t.integer :blogID, :null => false, :limit=>11
      t.timestamps
    end
    add_index :python_indices, [:blogID], :unique => true
    add_index :python_indices, [:updated_at]
  end
end
