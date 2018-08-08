module ApplicationHelper
  def escape_like(keyword)
    keyword.gsub(/[\\%_]/){|m| "\\#{m}"}
  end
end
