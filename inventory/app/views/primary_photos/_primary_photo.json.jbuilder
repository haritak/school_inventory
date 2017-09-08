json.extract! primary_photo, :id, :created_at, :updated_at
json.url primary_photo_url(primary_photo, format: :json)
