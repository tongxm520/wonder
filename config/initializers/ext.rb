class Time
  def china_time
    self.strftime("%Y-%m-%d %H:%M:%S")
  end
  
  def china_date
    self.strftime("%Y-%m-%d")
  end
end

class Array
  def paginate(options = {})
    page     = options[:page] || 1
    per_page = options[:per_page] || WillPaginate.per_page
    total    = options[:total_entries] || self.length

    WillPaginate::Collection.create(page, per_page, total) do |pager|
      pager.replace self[pager.offset, pager.per_page].to_a
    end
  end
end
