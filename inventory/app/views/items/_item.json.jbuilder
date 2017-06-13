json.extract! item, :id, :serial, :description, :photo_file, :photo_data, :created_at, :updated_at
json.url item_url(item, format: :json)
