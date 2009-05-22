require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe SqlConditionBuilder do
  before do
    @builder = SqlConditionBuilder.new
  end

  it "should be an empty string when no conditions given" do
    @builder.to_s.should == ""
  end

  it "should use a string given" do
    @builder.add_condition("foo")
    @builder.to_s.should == "foo"
  end

  it "should AND conditions" do
    @builder.add_condition("foo")
    @builder.add_condition("bar")
    @builder.to_s.should == "foo AND bar"
  end

  it "should use a bind variable" do
    @builder.add_condition("foo = ?", "bar")
    @builder.to_s.should == "foo = 'bar'"
  end

  it "should use multiple bind variables" do
    @builder.add_condition("one = ?", 1)
    @builder.add_condition("two = ?", 2)
    @builder.to_s.should == "one = 1 AND two = 2"
  end

  it "should return the bind variables flatten, when sent to_a" do
    @builder.add_condition("one = ?", 1)
    @builder.add_condition("two = ?", 2)
    @builder.to_a.should == ["one = ? AND two = ?", 1, 2]
  end

  it "should be able to add a condition simply" do
    @builder.one = 1
    @builder.to_a.should == ["one = ?", 1]
  end

  it "should use the correct bind variable" do
    @builder.one = 2
    @builder.to_a.should == ["one = ?", 2]
  end

  it "should use multiple bind variables" do
    @builder.one = 1
    @builder.one = 2
    @builder.to_a.should == ["one = ? AND one = ?", 1, 2]
  end

  it "should use the string given" do
    @builder.two = 2
    @builder.to_a.should == ["two = ?", 2]
  end

  it "should raise a NoMethodError if the method does not have =" do
    lambda { 
      @builder.one
    }.should raise_error(NoMethodError)
  end

  it "should not respond_to? @builder.one" do
    @builder.respond_to?(:one).should be_false
  end

  it "should respond_to a method it defines" do
    @builder.respond_to?(:to_a).should be_true
  end

  it "should respond_to? a method that ends with an equal sign" do
    @builder.respond_to?(:foo=).should be_true
  end

  it "should respond_to? method_missing when passed the include_private flag" do
    @builder.respond_to?(:method_missing, true).should be_true
  end

  it "should have method_missing as a private instance method" do
    @builder.private_methods.should include("method_missing")
  end

  it "should not respond_to? method_missing when not passed the include_private flag" do
    @builder.respond_to?(:method_missing).should be_false
  end

  it "should allow an empty bind variable" do
    @builder.add_condition "foo IS NULL"
    @builder.to_a.should == ["foo IS NULL"]
  end

  it "should allow a nil bind variable to be passed" do
    @builder.add_condition "foo = ?", nil
    @builder.to_a.should == ["foo = ?", nil]
  end
end
