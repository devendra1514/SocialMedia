module ThumbnailConcern
  extend ActiveSupport::Concern

  included do
    def process_thumbnail(file)
      if file.image?
        thumb_blob = file.variant(resize_to_fill: [100, 100]).processed
      elsif file.video?
        thumb_blob = file.preview(resize_to_fill: [300, 300]).processed
      end
    end
  end
end
