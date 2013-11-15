module GDash
  class View
    def ganglia_graph graph
      params = {
        :vl        => graph.vertical_label,
        :x         => graph.upper_limit,
        :n         => graph.lower_limit,
        :gtype     => graph.type,
        :glegend   => graph.legend ? "show" : "hide",
        :aggregate => graph.aggregate ? 1 : 0,
        "hreg[]"   => @scope.hosts,
        "mreg[]"   => graph.metrics.split(/\|/).map { |m| @scope.ganglia_prefix.present? ? "#{@scope.ganglia_prefix}.#{m}" : m }.join("|")
      }
      ganglia graph, params
    end

    def ganglia_report report
      params = { :g => report.report, :c => (report.cluster || @scope.ganglia_cluster) }
      params[:prefix] = (report.prefix || @scope.ganglia_prefix) if (report.prefix || @scope.ganglia_prefix)
      params["hreg[]"] = @scope.hosts if @scope.hosts
      params["h"] = @scope.host if @scope.host
      ganglia report, params
    end

    private

    def ganglia model, params
      window = model.window || @scope.window || self.window || GDash::Window.default
      data_center = @scope.data_center

      params = params.merge(window.ganglia_params).merge(model.options).merge({ :z => :xxlarge, :title => model.title, :embed => (model.embed ? 1 : 0) })
      query_string = params.map { |k, v| "#{k}=#{Rack::Utils.escape(v)}" }.join("&")
      xxlarge = "#{data_center.ganglia_host}/graph.php?#{query_string}".to_sym

      params = params.merge({ :z => model.size })
      query_string = params.map { |k, v| "#{k}=#{Rack::Utils.escape(v)}" }.join("&")
      medium = "#{data_center.ganglia_host}/graph.php?#{query_string}".to_sym

      html.a :href => xxlarge, :class => "click-enlarge" do
        html.img :src => medium, :xxlarge => xxlarge, :id => Rack::Utils.escape(params[:g]), :class => 'ganglia_graph'
      end
    end
  end
end
