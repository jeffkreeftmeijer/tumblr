class Tumblr
  class User
    attr_accessor :email, :password, :tumblr
  
    # creates a User object and authenticates the user through the Tumblr API to get user data.  
    def initialize(email, password, authenticate = true)
      self.email = email
      self.password = password
      if(authenticate)
        self.tumblr = Tumblr::Request.authenticate(email,password)['tumblr']
      end
    end
  end
end