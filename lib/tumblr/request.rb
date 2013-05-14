class Tumblr
  class Request
    
    # a GET request to http://[YOURUSERNAME].tumblr.com/api/read
    def self.read(options = {})
        response = HTTParty.get("http://#{Tumblr::blog}/api/read", :query => options)
      return response unless raise_errors(response)
    end
    
    # a POST request to http://www.tumblr.com/api/write
    def self.write(options = {})
      response = HTTParty.post('http://www.tumblr.com/api/write', :query => options)
      return(response) unless raise_errors(response)
    end
    
    # a POST request to http://www.tumblr.com/api/delete
    def self.delete(options = {})
      response = HTTParty.post('http://www.tumblr.com/api/delete', :query => options)
      return(response) unless raise_errors(response)
    end
    
    # a POST request to http://www.tumblr.com/api/authenticate
    def self.authenticate(email, password)
      HTTParty.post('http://www.tumblr.com/api/authenticate', :query => {:email => email, :password => password})
    end
    
    # raise tumblr response errors.
    def self.raise_errors(response)
      if(response.is_a?(Hash))
        message = "#{response[:code]}: #{response[:body]}"
        code = response[:code].to_i
      else
        message = "#{response.code}: #{response.body}"
        code = response.code.to_i
      end
      
      case code
        when 403
          raise(Forbidden.new, message)
        when 400
          raise(BadRequest.new, message)
        when 404
          raise(NotFound.new, message)
        when 201
          return false
      end        
    end
    
  end
end