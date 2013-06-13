require "spec_helper"

module GDash
  describe GangliaReport do
    let!(:data_center) { DataCenter.define :foo, :ganglia_host => "http://ganglia-host:1234/path/to/ganglia" }

    let :report do
      GangliaReport.new :foo do
        size "xlarge"
        title "The Graph Title"
        report "the_report"
        cluster "The Cluster"
        hosts "the-host-01|the-host-02"
        host "the-host-01"
        prefix "the-prefix"
      end
    end
    
    subject { report }

    it { should be_a Ganglia }
    
    its(:size) { should == "xlarge" }
    its(:title) { should == "The Graph Title" }
    its(:report) { should == "the_report" }
    its(:cluster) { should == "The Cluster" }
    its(:hosts) { should == "the-host-01|the-host-02" }
    its(:host) { should == "the-host-01" }
    its(:prefix) { should == "the-prefix" }
  end
end