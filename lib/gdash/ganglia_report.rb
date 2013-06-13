module GDash
  class GangliaReport < Widget
    include Ganglia

    attr :report, :cluster, :host, :hosts, :prefix
  end
end