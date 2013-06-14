class CreateSqlIndices < ActiveRecord::Migration
  def change
    create_table :sql_indices do |t|
      t.integer :blogID, :null => false, :limit=>11

      t.timestamps
    end
    add_index :sql_indices, [:blogID], :unique => true
  end
end
