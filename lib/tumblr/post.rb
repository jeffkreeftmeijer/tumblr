class Tumblr  
  class Post
    
    # works just like ActiveRecord's find. (:all, :first, :last or id)
    def self.find(*args)
      extra_options = args.last.is_a?(Hash) ?  args.pop : {} 
        
      case args.first
        when :all then return self.find_every(extra_options)
        when :first then return self.find_initial(extra_options)
        when :last then return self.find_last(extra_options)
        else return self.find_from_id(args.first)
      end      
    end
    
    # count the posts
    def self.count(options = {})
      
      #puts balh = {:num => 1}.merge(options).to_yaml      
      response = Tumblr::Request.read({:num => 1}.merge(options))
      if(options.empty?)
        #puts response['tumblr']['posts'].to_yaml
        #puts "*****"
      end
      response['tumblr']['posts']['total'].to_i
      
    end

    # find the first post
    def self.find_initial(options)
      total = self.count
      options = {:start => (total - 1),  :num => 1} if(options.empty?)      
      response = Tumblr::Request.read(options)

      return response['tumblr']['posts']['post'].first unless(options == {:start => (total - 1),  :num => 1})
      response['tumblr']['posts']['post']
    end
  
    # find the last post
    def self.find_last(options)
      response = Tumblr::Request.read({:num => 1}.merge(options))
      response['tumblr']['posts']['post']
    end
  
    # find all posts
    def self.find_every(options)
      amount = (Tumblr::Post.count(options).to_f / 50).ceil
      options = {:num => 50}.merge(options)
    
      responses = []
      amount.times do |count|
        responses << Tumblr::Request.read(options.merge({:start => (count.to_i * 50)}))
        #puts options.merge({:start => (count.to_i * 50)}).to_yaml
      end
          
      response = {'tumblr' => {'posts' => {'post' => []}}}
      responses.each do |r|
        r['tumblr']['posts']['post'].each { | p | response['tumblr']['posts']['post'] << p }
      end
      
      #puts response['tumblr']['posts']['post'].length.to_yaml
    
      return [response['tumblr']['posts']['post']] unless(response['tumblr']['posts']['post'].is_a?(Array))  
      response['tumblr']['posts']['post']
    end
  
    # find a post by id
    def self.find_from_id(id)
      response = Tumblr::Request.read(:id => id)
      response['tumblr']['posts']['post']
    end
    
    # alias of find(:all)
    def self.all(options = {})
      self.find(:all, options)
    end
    
    # alias of find(:first)
    def self.first(options = {})
      self.find(:first, options)
    end
    
    # alias of find(:last)
    def self.last(options = {})
      self.find(:last, options)
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
      options = args.last.is_a?(Hash) ?  args.pop : {}

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