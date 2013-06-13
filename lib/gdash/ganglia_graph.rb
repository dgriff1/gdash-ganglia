module GDash
  class GangliaGraph < Widget
    include Ganglia

    attr :hosts, :metrics, :vertical_label, :upper_limit, :lower_limit, :type, :legend
    attr :aggregate, :default => true

    def limits range
      self.limits = range
    end

    def limits= range
      self.lower_limit = range.begin
      self.upper_limit = range.end
    end
  end
end