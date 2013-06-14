class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title, :null=>false, :limit=>200
      t.string :author, :null=>false, :limit=>50
      t.string :category, :null=>false, :limit=>200
      t.string :abstract, :null=>false, :limit=>300
      t.text :content, :null=>false, :limit=>4294967295
      t.integer :views, :null=>false, :default=>0, :limit => 8

      t.timestamps
    end
    
    add_index :blogs, [:title, :author], :unique=>true
    add_index :blogs, [:author]
    add_index :blogs, [:views]
  end
end

