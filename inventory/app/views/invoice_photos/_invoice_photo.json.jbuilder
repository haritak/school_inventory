json.extract! invoice_photo, :id, :created_at, :updated_at
json.url invoice_photo_url(invoice_photo, format: :json)
