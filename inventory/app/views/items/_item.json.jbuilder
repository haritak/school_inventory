json.extract! item, :id, :serial, :description, :page_url, :photo_data, :created_at, :updated_at
json.url item_url(item, format: :json)
