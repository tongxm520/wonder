require 'spec_helper'

describe User do
	it "should have the method" do
	  bool = User.respond_to? :another_user?
	  bool.should eq(true)
	end
	
	it "doesn't include backward compatibility in const_missing backtrace" do
    exception = nil
    begin
      Abc.method
    rescue Exception => exception
    end
    exception.backtrace.find { |l| l =~ /backward_compatibility/ }.should be_nil
  end
end


=begin
RSpec.describe User do
  it "should respond_to the method" do
    bool = User.respond_to? :another_user?
    bool.should eq(true)
  end
end


describe "#let!" do
  let!(:creator) do
    Class.new do
      @count = 0
      def self.count
        @count += 1
      end
    end
  end

  it "evaluates the value non-lazily" do
    lambda { creator.count }.should_not raise_error
  end

  it "does not interfere between tests" do
    creator.count.should eq(1)
  end
end
=end

