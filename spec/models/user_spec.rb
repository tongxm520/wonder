require 'spec_helper'

describe User do
	it "should have the method" do
	  bool = User.respond_to? :another_user?
	  bool.should eq(true)
	end
end

#RSpec.describe User do
#  it "should respond_to the method" do
#    bool = User.respond_to? :another_user?
#    bool.should eq(true)
#  end
#end


#describe "#let!" do
#  let!(:creator) do
#    Class.new do
#      @count = 0
#      def self.count
#        @count += 1
#      end
#    end
#  end

#  it "evaluates the value non-lazily" do
#    lambda { creator.count }.should_not raise_error
#  end

#  it "does not interfere between tests" do
#    creator.count.should eq(1)
#  end
#end


