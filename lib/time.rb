class Time
  def to_ms
    (1000.0 * self.to_f).round(3)
  end
end