json.records @sleep_records do |record|
  json.id record.id
  json.user do
    json.id record.user.id
    json.name record.user.name
  end
  json.clock_in record.clock_in
  json.clock_out record.clock_out
  json.sleep_duration record.clock_out - record.clock_in
end

json.pagination do
  json.total_pages @pagy.pages
  json.current_page @pagy.page
  json.next_page @pagy.next
  json.prev_page @pagy.prev
end
