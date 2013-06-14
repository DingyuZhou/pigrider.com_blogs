class CreateCssIndices < ActiveRecord::Migration
  def change
    create_table :css_indices do |t|
      t.integer :blogID, :null => false, :limit=>11

      t.timestamps
    end
    add_index :css_indices, [:blogID], :unique => true
  end
end