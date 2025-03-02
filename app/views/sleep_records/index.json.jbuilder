json.records @sleep_records do |record|
  json.id record.id
  json.user_id record.user_id
  json.clock_in record.clock_in
  json.clock_out record.clock_out
  json.created_at record.created_at
end

json.pagination do
  json.total_pages @pagy.pages
  json.current_page @pagy.page
  json.next_page @pagy.next
  json.prev_page @pagy.prev
end
