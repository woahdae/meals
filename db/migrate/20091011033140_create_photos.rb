class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.column :parent_id,  :integer
      t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      
      t.column :photoable_id, :integer
      t.column :type, :string

      t.timestamps
    end
    
    add_index :photos, :parent_id
    add_index :photos, :photoable_id
    add_index :photos, :type
  end

  def self.down
    drop_table :photos
  end
end
