class CreateCssIndices < ActiveRecord::Migration
  def change
    create_table :css_indices, :id=>false do |t|
      t.integer :blogID, :null => false, :limit=>11
      t.timestamps
    end
    add_index :css_indices, [:blogID], :unique => true
    add_index :css_indices, [:updated_at]
  end
end