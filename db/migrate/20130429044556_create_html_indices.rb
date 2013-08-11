class CreateHtmlIndices < ActiveRecord::Migration
  def change
    create_table :html_indices, :id=>false do |t|
      t.integer :blogID, :null => false, :limit=>11
      t.timestamps
    end
    add_index :html_indices, [:blogID], :unique => true
    add_index :html_indices, [:updated_at]
  end
end