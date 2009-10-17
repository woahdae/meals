##
# Photo is just an abstract class for documentation because of the
# half-polymorphic approach. All photos have a photoable_id column,
# like a normal polymorphic relationship would. However, there isn't
# a photoable_type class, and instead just type (i.e. STI). Subclasses
# define their belongs to, which plays the role of a photoable_type
# but without the extra database field. The real purpose, though, is
# so we can define custom has_attachments for every type of photo,
# most notably resize_to and thumbnails.
# 
# See RecipePhoto for an example
class Photo < ActiveRecord::Base
  # belongs_to :photoable, :polymorphic => true
  
  # has_attachment :content_type => :image, 
  #                :storage      => :file_system, 
  #                :max_size     => 500.kilobytes,
  #                :resize_to    => '640x480>',
  #                :thumbnails   => { :medium => "310x240>":thumb => '100x100>' }
                 
  # validates_as_attachment # optional
end
