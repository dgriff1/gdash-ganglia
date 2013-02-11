module GDash
  class GangliaReport < Ganglia
    attr_accessor :report, :cluster, :host, :hosts, :prefix

    def clone
      self.class.new :name => name, :embed => embed, :data_center => data_center, :window => window, :size => size, :title => title, :report => report, :cluster => cluster, :host => host, :hosts => hosts, :prefix => prefix
    end

    private

    def url_params
      params = super.merge({
        :g => report,
        :c => cluster
      })
      params[:prefix] = prefix if prefix
      params["hreg[]"] = hosts if hosts
      params["h"] = host if host
      params
    end
  end
end