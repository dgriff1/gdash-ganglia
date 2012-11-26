require "spec_helper"

class TestWidget < GDash::Widget
  attr_accessor :foo, :bar

  def clone
    self.class.new :foo => foo, :bar => bar
  end

  def == other
    other.name == self.name and other.foo == self.foo and other.bar == self.bar
  end
end

module GDash
  describe Widget do
    let(:widget) { TestWidget.new }
    subject { widget }

    describe :ganglia_graph do
      let(:graph) { GangliaGraph.define :some_graph }
      before { GangliaGraph.stub! :new => graph }
      before { widget.ganglia_graph :some_graph }

      subject { widget.children.last }

      it { should == graph }
      its(:parent) { should == widget }

      it "yields the ganglia graph" do
        GangliaGraph.stub!(:new).and_yield(graph).and_return graph

        yielded = nil
        subject.ganglia_graph :some_graph do |g|
          yielded = g
        end

        yielded.should == graph
      end
    end

    describe :ganglia_report do
      let(:report) { GangliaReport.define :some_report }
      before { GangliaReport.stub! :new => report }
      before { widget.ganglia_report :some_report }

      subject { widget.children.last }

      it { should == report }
      its(:parent) { should == widget }

      it "yields the ganglia report" do
        GangliaReport.stub!(:new).and_yield(report).and_return report

        yielded = nil
        subject.ganglia_report :some_report do |g|
          yielded = g
        end

        yielded.should == report
      end
    end
  end
end