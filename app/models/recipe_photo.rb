class RecipePhoto < Photo
  belongs_to :recipe, :foreign_key => "photoable_id"
  
  has_attachment :content_type => :image, 
                 :storage      => :file_system,
                 :processor    => "Rmagick",
                 :max_size     => 6.megabytes,
                 :resize_to    => '640x480>',
                 :thumbnails   => { :medium => "310x240>", :thumb => '100x100>' }

  validates_as_attachment
end
