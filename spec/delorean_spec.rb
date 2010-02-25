require 'rubygems'
require File.dirname(__FILE__) + "/../lib/delorean"

describe Delorean do
  
  after(:each) do
    Delorean.back_to_the_present
  end
  
  describe "time_travel_to" do
    it "should travel through time" do
      past_date = Time.utc(2009,1,1,10,30)
      Delorean.time_travel_to past_date
      Time.now.should be_close(past_date, 1)
    end
    
    it "should travel through time several times" do
      past_date = Date.new(2009,1,1)
      Delorean.time_travel_to Date.new(2009,2,20)
      Delorean.time_travel_to past_date
      Date.today.should == past_date
    end
    
    it "should travel to string times" do
      two_minutes_from_now = Time.now + 120
      Delorean.time_travel_to "2 minutes from now"
      Time.now.should be_close(two_minutes_from_now, 1)
    end
  end
  
  describe "back_to_the_present" do
    it "should stay in the present if in the present" do
      today = Date.today
      Delorean.back_to_the_present
      Date.today.should == today
    end
    
    it "should go back to the present if not in the present" do
      today = Date.today
      Delorean.time_travel_to Time.local(2009,2,2,1,1)
      Delorean.back_to_the_present
      Date.today.should == today
    end
    
    it "should go back to the original present if travelled through time several times" do
      today = Date.today
      2.times { Delorean.time_travel_to Time.local(2009,2,2,1,1) }
      Delorean.back_to_the_present
      Date.today.should == today
    end
  end
  
  describe "time_travel_to with block" do
    it "should travel through time" do
      past_date = Time.utc(2009,1,1,10,30)
      Delorean.time_travel_to(past_date) do
        Time.now.should be_close(past_date, 1)
      end
    end
    
    it "should return to the future" do
      today = Date.today
      Delorean.time_travel_to(Time.utc(2009,2,2,10,30)) {}
      Date.today.should == today
    end
    
    it "should travel through time several times" do
      Delorean.time_travel_to(Time.utc(2009,2,2,10,40)) do
        Delorean.time_travel_to(Time.utc(2009,1,1,22,45)) do
          Date.today.should == Date.new(2009,1,1)
        end
      end
    end
    
    it "should still return to the future" do
      today = Date.today
      Delorean.time_travel_to(Time.utc(2009,2,2,10,40)) do
        Delorean.time_travel_to(Time.utc(2009,1,1,10,40)) {}
        Date.today.should == Date.new(2009,2,2)
      end
      Date.today.should == today
    end
    
    it "should travel to string times" do
      two_minutes_ago = Time.now - 120
      Delorean.time_travel_to("2 minutes ago") do
        Time.now.should be_close(two_minutes_ago, 1)
      end
    end
  end

  describe "jump" do
    it "should jump the given number of seconds to the future" do
      expected = Time.now + 60
      Delorean.jump 60
      Time.now.should be_close(expected, 1)
    end
  end
end