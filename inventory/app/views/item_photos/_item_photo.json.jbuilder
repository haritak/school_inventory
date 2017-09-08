json.extract! item_photo, :id, :created_at, :updated_at
json.url item_photo_url(item_photo, format: :json)
