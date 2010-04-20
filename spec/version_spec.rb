require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe SqlConditionBuilder::VERSION do
  it "should be @ version 0.1.0" do
    SqlConditionBuilder::VERSION.should == "0.1.0"
  end
end
