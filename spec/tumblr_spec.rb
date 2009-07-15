require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Tumblr do
  it "should set the current blog" do
    Tumblr::blog = 'myblog'
    Tumblr::blog.should eql('myblog')
  end
end

describe Tumblr::Request, ".read" do
  before do    
    Tumblr::Request.stub!(:read).
      with().
      and_return(
        Crack::XML.parse(
          File.read("spec/fixtures/read_0_0.xml")
        )
      )
  end
      
  it "should return a tumblr object" do
    response = Tumblr::Request.read
    response['tumblr'].is_a?(Hash).should eql(true)
  end
  
  it "should even return a tumblr object when no blog specified" do
    Tumblr::blog = nil
    response = Tumblr::Request.read
    response['tumblr'].is_a?(Hash).should eql true
  end
end

describe Tumblr::Post, ".count" do
  before do
   Tumblr::Request.stub!(:read).
     with({:num => 1}).
     and_return(
       Crack::XML.parse(
         File.read("spec/fixtures/read_0_1.xml")
       )
     )
     
   Tumblr::Request.stub!(:read).
     with({:num => 1, :type => 'photo'}).
     and_return(
       Crack::XML.parse(
         File.read("spec/fixtures/read_0_1_photo.xml")
       )
     )
  end
  
  it "should return 120" do
    response = Tumblr::Post.count
    response.should eql(120)
  end
  
  it "should return 2" do
    response = Tumblr::Post.count(:type => 'photo')
    response.should eql(2)
  end
end

describe Tumblr::Post, ".all" do
  before do    
    Tumblr::Request.stub!(:read).
      with({:num => 50, :start => 0}).
      and_return(
        Crack::XML.parse(
          File.read("spec/fixtures/read_0_50.xml")
        )
      )
    Tumblr::Request.stub!(:read).
      with({:num => 50, :start => 50}).
      and_return(
        Crack::XML.parse(
          File.read("spec/fixtures/read_50_50.xml")
        )
      )
     
    Tumblr::Request.stub!(:read).
      with({:num => 50, :start => 100}).
      and_return(
        Crack::XML.parse(
          File.read("spec/fixtures/read_100_50.xml")
        )
      )
      
    Tumblr::Request.stub!(:read).
      with({:num => 50, :start => 0, :type => 'photo'}).
      and_return(
        Crack::XML.parse(
          File.read("spec/fixtures/read_0_50_photo.xml")
        )
      )
    
   Tumblr::Request.stub!(:read).
     with({:num => 1}).
     and_return(
       Crack::XML.parse(
         File.read("spec/fixtures/read_0_1.xml")
       )
     )
      
      Tumblr::Request.stub!(:read).
        with({:num => 1, :type => 'photo'}).
        and_return(
          Crack::XML.parse(
            File.read("spec/fixtures/read_0_1_photo.xml")
          )
        )
  end
  
  it "should return 120 posts" do
    response = Tumblr::Post.all
    response.length.should eql(120)
  end
  
  it "should return 2 photos" do
    response = Tumblr::Post.all(:type => 'photo')
    response.length.should eql(2)
  end
  
  it "shoud always return an array" do
    response = Tumblr::Post.all
    response.is_a?(Array).should eql(true)
  end
end

describe Tumblr::Post, ".first" do
  before do
    Tumblr::Request.stub!(:read).
      with({:num => 1}).
      and_return(
        Crack::XML.parse(
          File.read("spec/fixtures/read_0_1.xml")
        )
      )
    Tumblr::Request.stub!(:read).
      with({:type => 'photo'}).
      and_return(
        Crack::XML.parse(
          File.read("spec/fixtures/read_0_0_photo.xml")
        )
      )      
    Tumblr::Request.stub!(:read).
      with({:start => 119, :num => 1}).
      and_return(
        Crack::XML.parse(
          File.read("spec/fixtures/read_119_1.xml")
        )
      )
  end
  
  it "should return 1 post with id 108796131" do
    response = Tumblr::Post.first
    response['id'].should eql("108796131")
  end
  
  it "should return 1 post with the type photo" do
    response = Tumblr::Post.first(:type => 'photo')
    response['id'].should eql("141569188")
  end
    
  it "shoud never return an array" do
    response = Tumblr::Post.first
    response.is_a?(Array).should eql(false)
  end
end

describe Tumblr::Post, ".last" do
  before do    
    Tumblr::Request.stub!(:read).
      with({:num => 1}).
      and_return(
        Crack::XML.parse(
          File.read("spec/fixtures/read_0_1.xml")
        )
      )
    
    Tumblr::Request.stub!(:read).
      with({:num => 1, :type => 'photo'}).
      and_return(
        Crack::XML.parse(
          File.read("spec/fixtures/read_0_1_photo.xml")
        )
      )
  end
  
  it "should return 1 post with id 142005160" do
    response = Tumblr::Post.last
    response['id'].should eql("142005160")
  end
  
  it "should return 1 post with the type photo" do
    response = Tumblr::Post.last(:type => 'photo')
    response['id'].should eql("141569188")
  end
  
  it "shoud never return an array" do
    response = Tumblr::Post.last
    response.is_a?(Array).should eql(false)
  end
end

describe Tumblr::Post, ".find" do
  before do
    Tumblr::Request.stub!(:read).
      with({:id => 108796131}).
      and_return(
        Crack::XML.parse(
          File.read("spec/fixtures/read_108796131.xml")
        )
      )
  end
  
  it "should return 1 post with id 108796131" do
    response = Tumblr::Post.find(108796131)
    response['id'].should eql("108796131")
  end
  
  it "shoud never return an array" do
    response = Tumblr::Post.find(108796131)
    response.is_a?(Array).should eql(false)
  end
end

describe Tumblr::User, ".initialize" do
  it "should have an email" do
    user = Tumblr::User.new('myname', 'mypassword')
    user.email.should eql('myname')
  end
  
  it "should have a password" do
    user = Tumblr::User.new('myname', 'mypassword')
    user.password.should eql('mypassword')
  end
end