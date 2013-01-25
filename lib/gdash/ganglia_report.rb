module GDash
  class GangliaReport < Ganglia
    attr_accessor :report, :cluster, :host, :prefix

    def clone
      self.class.new :name => name, :embed => embed, :data_center => data_center, :window => window, :size => size, :title => title, :report => report, :cluster => cluster, :host => host, :prefix => prefix
    end

    private

    def url_params
      params = super.merge({
        :g => report,
        :c => cluster
      })
      params[:prefix] = prefix if prefix
      params[:h] = host if host
      params
    end
  end
end