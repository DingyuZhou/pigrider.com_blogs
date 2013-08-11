class CreateJavascriptIndices < ActiveRecord::Migration
  def change
    create_table :javascript_indices, :id=>false do |t|
      t.integer :blogID, :null => false, :limit=>11
      t.timestamps
    end
    add_index :javascript_indices, [:blogID], :unique => true
    add_index :javascript_indices, [:updated_at]
  end
end