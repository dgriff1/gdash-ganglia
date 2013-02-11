require "spec_helper"

module GDash
  describe GangliaReport do
    let!(:data_center) { DataCenter.define :foo, :ganglia_host => "http://ganglia-host:1234/path/to/ganglia" }

    let :report do
      described_class.new do |report|
        report.data_center = :foo
        report.window = Window.new(:hour, :length => 1.hour)
        report.size = "xlarge"
        report.title = "The Graph Title"
        report.report = "the_report"
        report.cluster = "The Cluster"
        report.hosts = "the-host-01|the-host-02"
        report.host = "the-host-01"
        report.prefix = "the-prefix"
      end
    end
    
    subject { report }

    it { should be_a Ganglia }
    
    its(:data_center) { should == data_center }
    its(:window) { should be_a Window }
    its(:size) { should == "xlarge" }
    its(:title) { should == "The Graph Title" }
    its(:report) { should == "the_report" }
    its(:cluster) { should == "The Cluster" }
    its(:hosts) { should == "the-host-01|the-host-02" }
    its(:host) { should == "the-host-01" }
    its(:prefix) { should == "the-prefix" }

    describe "#clone" do
      subject { report.clone }

      its(:data_center) { should == report.data_center }
      its(:window) { should == report.window }
      its(:name) { should == report.name }
      its(:embed) { should == report.embed }
      its(:size) { should == report.size }
      its(:title) { should == report.title }
      its(:report) { should == report.report }
      its(:cluster) { should == report.cluster }
      its(:hosts) { should == report.hosts }
      its(:host) { should == report.host }
      its(:prefix) { should == report.prefix }
    end

    describe "#to_url" do
      subject { report.to_url }

      it { should =~ /z=xlarge/ }
      it { should =~ /title=The\+Graph\+Title/ }
      it { should =~ /g=the_report/ }
      it { should =~ /h=the-host-01/ }
      it { should =~ /hreg\[\]=the-host-01|the-host-02/ }
      it { should =~ /c=The\+Cluster/ }
      it { should =~ /prefix=the-prefix/ }

      it "includes the window" do
        report.window.ganglia_params.each do |k, v|
          subject.should =~ /#{Regexp.escape "#{k}=#{Rack::Utils.escape(v)}"}/
        end
      end
      
      context "without hosts" do
        before { report.hosts = nil }
        it { should_not =~ /hreg\[\]=/ }
      end
      
      context "without host" do
        before { report.host = nil }
        it { should_not =~ /h=/ }
      end
    end
  end
end