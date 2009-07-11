require 'httparty'
require 'active_support'

require 'tumblr/user'
require 'tumblr/request'
require 'tumblr/post'

module Tumblr
  mattr_accessor :blog
  
  # tumblr errors
  class TumblrError < StandardError; end
  # tumblr 403 errors
  class Forbidden   < TumblrError; end
  # tumblr 400 errors
  class BadRequest  < TumblrError; end  
  # tumblr 404 errors
  class Notfound    < TumblrError; end  
  
end
