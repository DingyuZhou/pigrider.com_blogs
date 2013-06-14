class CreateJavascriptIndices < ActiveRecord::Migration
  def change
    create_table :javascript_indices do |t|
      t.integer :blogID, :null => false, :limit=>11

      t.timestamps
    end
    add_index :javascript_indices, [:blogID], :unique => true
  end
end