require 'rubygems' 
gem 'httparty', "<= 4.3"
require 'httparty'

require 'tumblr/user'
require 'tumblr/request'
require 'tumblr/post'

class Tumblr    
  class << self; attr_accessor :blog end
  
  # tumblr errors
  class TumblrError < StandardError; end
  # tumblr 403 errors
  class Forbidden   < TumblrError; end
  # tumblr 400 errors
  class BadRequest  < TumblrError; end  
  # tumblr 404 errors
  class NotFound    < TumblrError; end
  
end