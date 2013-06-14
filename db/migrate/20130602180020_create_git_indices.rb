class CreateGitIndices < ActiveRecord::Migration
  def change
    create_table :git_indices do |t|
      t.integer :blogID, :null => false, :limit=>11

      t.timestamps
    end
    add_index :git_indices, [:blogID], :unique => true
  end
end
