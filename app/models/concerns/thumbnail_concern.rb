module ThumbnailConcern
  extend ActiveSupport::Concern

  included do
    def process_thumbnail(file)
      # this can be process in background using background job
      return unless file.representable?
      if file.image?
        file.variant(resize_to_fill: SMALL_THUMB_SIZE).processed
      elsif file.video?
        file.preview(resize_to_fill: MEDIUM_THUMB_SIZE).processed
      end
    end
  end
end
