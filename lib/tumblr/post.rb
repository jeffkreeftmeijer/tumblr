module Tumblr
  class Post
    
    # works just like ActiveRecord's find. (:all, :first, :last or id)
    def self.find(*args)
      options = args.extract_options!
      
      if((user = args.second).is_a?(Tumblr::User))        
        options = options.merge(
          :email =>     user.email,
          :password =>  user.password
        )        
      end
          
      case args.first
        when :first then find_initial(options)
        when :last  then find_last(options)
        when :all   then find_every(options)
        else             find_from_id(args.first, options)
      end
    end
  
    # find the first post
    def self.find_initial(options)
      Tumblr::Request.read(options.merge(:start => 0, :num => 1))
    end
  
    # find the last post
    def self.find_last(options)
      total = all['tumblr']['posts']['total'].to_i
      Tumblr::Request.read(options.merge(:start => total - 1, :num => 1))
    end
    
    # find all posts (the maximum amount of posts is 50, don't blame the messenger)
    def self.find_every(options)
      Tumblr::Request.read(options.merge(:num => 50))
    end
  
    # find a post by id
    def self.find_from_id(id, options)
      Tumblr::Request.read(options.merge(:id => id))
    end
  
    # alias of find(:all)
    def self.all(*args)
      self.find(:all, *args)
    end
    
    # alias of find(:first)
    def self.first(*args)
      self.find(:first, *args)
    end    
    
    # alias of find(:last)
    def self.last(*args)
      self.find(:last, *args)
    end
    
    # create a new post
    def self.create(*args)
      options = process_options(*args)
      Tumblr::Request.write(options)
    end
    
    # update a post
    def self.update(*args)
      options = process_options(*args)
      Tumblr::Request.write(options)
    end
    
    # destroy a post
    def self.destroy(*args)
      options = process_options(*args)
      Tumblr::Request.delete(options)
    end
    
    # extracts options from the arguments, converts a user object to :email and :password params and fixes the :post_id/'post-id' issue.
    def self.process_options(*args)
      options = args.extract_options!

      if((user = args.first).is_a?(Tumblr::User))        
        options = options.merge(
          :email =>     user.email,
          :password =>  user.password
        )
      end
            
      if(options[:post_id])
        options['post-id'] = options[:post_id]
        options[:post_id] = nil
      end
      
      return options
    end
  end
end

