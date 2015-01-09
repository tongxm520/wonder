class Time
  def china_time
    self.strftime("%Y-%m-%d %H:%M:%S")
  end
  
  def china_date
    self.strftime("%Y-%m-%d")
  end
end
