module UsersHelper
    def gravatar_for(user, size: 70)
        gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url ="https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end

    # Returns the current logged-in user (if any).
    def current_user
        if (user_id = session[:user_id]) 
            @current_user ||= User.find_by(id: user_id) 
        elsif (user_id = cookies.encrypted[:user_id]) 
            user = User.find_by(id: user_id) 
            if user && user.authenticated?(cookies[:remember_token]) 
                log_in(user) 
                @current_user = user
            end 
        end
    end

end
