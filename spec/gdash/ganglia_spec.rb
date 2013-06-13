require "spec_helper"

class G < GDash::Base
  include GDash::Ganglia
end

module GDash
  describe Ganglia do
    let :ganglia do
      G.new :foo do
        window Window.all.last
        size "xlarge"
        title "The Graph Title"
        embed true
        custom :foo => :bar, :baz => :quux
        custom :a => :b
      end
    end
    
    subject { ganglia }

    its(:size) { should == "xlarge" }
    its(:title) { should == "The Graph Title" }
    its(:embed) { should be_true }
    its(:window) { should == Window.all.last }

    describe "#size" do
      context "default" do
        subject { G.new(:foo).size }
        it { should == "large" }
      end

      it "validates that it is in Ganglia::SIZES" do
        Ganglia::SIZES.each do |size|
          expect { subject.size = size }.to_not raise_error ArgumentError
        end
        expect { subject.size = :foobar }.to raise_error ArgumentError
      end
    end

    describe "#embed" do
      context "default" do
        subject { G.new(:foo).embed }
        it { should be_true }
      end
    end

    describe "#window" do
      context "default" do
        subject { G.new(:foo).window }
        it { should == Window.default }
      end
    end
  end
end