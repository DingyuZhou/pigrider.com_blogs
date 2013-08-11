class CreateSqlIndices < ActiveRecord::Migration
  def change
    create_table :sql_indices, :id=>false do |t|
      t.integer :blogID, :null => false, :limit=>11
      t.timestamps
    end
    add_index :sql_indices, [:blogID], :unique => true
    add_index :sql_indices, [:updated_at]
  end
end
