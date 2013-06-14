class CreatePythonIndices < ActiveRecord::Migration
  def change
    create_table :python_indices do |t|
      t.integer :blogID, :null => false, :limit=>11

      t.timestamps
    end
    add_index :python_indices, [:blogID], :unique => true
  end
end
