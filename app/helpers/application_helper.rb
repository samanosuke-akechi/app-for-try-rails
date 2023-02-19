module ApplicationHelper
  def google_map_api_key
    ENV.fetch('GOOGLE_MAP_API_KEY')
  end

  def fields_for_index(objects, object)
    object.id.presence || "#{objects.find_index(object)}#{Time.current.to_i}".to_i
  end
end
