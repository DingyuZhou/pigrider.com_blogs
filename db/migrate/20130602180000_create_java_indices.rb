class CreateJavaIndices < ActiveRecord::Migration
  def change
    create_table :java_indices, :id=>false do |t|
      t.integer :blogID, :null => false, :limit=>11
      t.timestamps
    end
    add_index :java_indices, [:blogID], :unique => true
    add_index :java_indices, [:updated_at]
  end
end
