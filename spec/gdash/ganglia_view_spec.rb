require "spec_helper"

module GDash
  describe View, :type => :feature do
    let!(:data_center) { DataCenter.define :foo, :ganglia_host => "http://ganglia-host:1234/path/to/ganglia" }

    describe "#ganglia_graph" do
      let(:ganglia_graph) do
        GangliaGraph.new :foo do
          window Window.all.last
          size "xlarge"
          title "The Graph Title"
          vertical_label "A Label"
          limits (1..10)
          hosts "the-host-0[123]"
          metrics "metric.name.[\\d]"
          type "stack"
          legend true
          embed true
          options :foo => :bar, :baz => :quux
          options :a => :b
        end
      end

      let(:view) { View.new(ganglia_graph) }
      subject do
        view.with_scope :data_center => data_center do
          view.to_html
        end
      end

      it { should have_selector "img" }

      it { should =~ /http:\/\/ganglia-host:1234\/path\/to\/ganglia/ }
      it { should =~ /embed=1/ }
      it { should =~ /foo=bar/ }
      it { should =~ /baz=quux/ }
      it { should =~ /a=b/ }

      it { should =~ /z=xlarge/ }
      it { should =~ /title=The\+Graph\+Title/ }
      it { should =~ /vl=A\+Label/ }
      it { should =~ /x=10/ }
      it { should =~ /n=1/ }
      it { should =~ /hreg\[\]=#{Rack::Utils.escape("the-host-0[123]")}/ }
      it { should =~ /mreg\[\]=#{Rack::Utils.escape("metric.name.[\\d]")}/ }
      it { should =~ /gtype=stack/ }
      it { should =~ /aggregate=1/ }

      context "with legend" do
        before { ganglia_graph.legend = true }
        it { should =~ /glegend=show/ }
      end

      context "without legend" do
        before { ganglia_graph.legend = false }
        it { should =~ /glegend=hide/ }
      end

      it "includes the window" do
        Window.all.last.ganglia_params.each do |k, v|
          subject.should =~ /#{Regexp.escape "#{k}=#{Rack::Utils.escape(v)}"}/
        end
      end
    end

    describe "#ganglia_report" do
      let(:ganglia_report) do
        GangliaReport.new :foo do
          window Window.all.last
          size "xlarge"
          title "The Graph Title"
          report "the_report"
          cluster "The Cluster"
          hosts "the-host-01|the-host-02"
          host "the-host-01"
          prefix "the-prefix"
          embed true
          options :foo => :bar, :baz => :quux
          options :a => :b
        end
      end

      let(:view) { View.new(ganglia_report) }
      subject do
        view.with_scope :data_center => data_center do
          view.to_html
        end
      end

      it { should have_selector "img.click-enlarge" }

      it { should =~ /http:\/\/ganglia-host:1234\/path\/to/ }
      it { should =~ /embed=1/ }
      it { should =~ /foo=bar/ }
      it { should =~ /baz=quux/ }
      it { should =~ /a=b/ }

      it { should =~ /z=xlarge/ }
      it { should =~ /title=The\+Graph\+Title/ }
      it { should =~ /g=the_report/ }
      it { should =~ /h=the-host-01/ }
      it { should =~ /hreg\[\]=the-host-01|the-host-02/ }
      it { should =~ /c=The\+Cluster/ }
      it { should =~ /prefix=the-prefix/ }

      it { should =~ /id="the_report"/ }
      it { should =~ /class="ganglia_graph"/ }

      it "includes the window" do
        Window.all.last.ganglia_params.each do |k, v|
          subject.should =~ /#{Regexp.escape "#{k}=#{Rack::Utils.escape(v)}"}/
        end
      end

      context "without hosts" do
        before { ganglia_report.hosts = nil }
        it { should_not =~ /hreg\[\]=/ }
      end

      context "without host" do
        before { ganglia_report.host = nil }
        it { should_not =~ /h=/ }
      end
    end
  end
end
