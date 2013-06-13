require "spec_helper"

module GDash
  describe GangliaGraph do
    let!(:data_center) { DataCenter.define :foo, :ganglia_host => "http://ganglia-host:1234/path/to/ganglia" }

    let :graph do
      GangliaGraph.new :foo do
        size "xlarge"
        title "The Graph Title"
        vertical_label "A Label"
        limits (1..10)
        hosts "the-host-0[123]"
        metrics "metric.name.[\\d]"
        type "stack"
        legend true
      end
    end
    
    subject { graph }

    it { should be_a Ganglia }
    
    its(:hosts) { should == "the-host-0[123]" }
    its(:metrics) { should == "metric.name.[\\d]" }
    its(:vertical_label) { should == "A Label" }
    its(:upper_limit) { should == 10 }
    its(:lower_limit) { should == 1 }
    its(:type) { should == "stack" }
    its(:legend) { should be_true }
    its(:aggregate) { should be_true }
  end
end