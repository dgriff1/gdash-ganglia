module GDash
  class GangliaReport < Ganglia
    attr_accessor :report, :cluster, :host, :prefix

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