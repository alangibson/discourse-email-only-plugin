class LonersController < ApplicationController

    # Make sure there is a staged user in the db
    def ensure_user
  
      # See if staged user exists
      user = User.where(staged: true).with_email(params[:email].strip.downcase).first
  
      # Create a staged user manually
      if !user
        user = User.new
        user.staged = true
        user.email = params[:email]
        user.active = false
        user.save!
      end
      
      user
    end
  
    # Watch topic as a staged user
    def watch
  
      user = ensure_user
  
      topic = Topic.find(params[:topic_id].to_i)
      TopicUser.change(user, topic.id, notification_level: params[:notification_level].to_i)
  
    end
  
    # Reply to topic as a staged user
    def reply
   
      user = ensure_user
  
      manager = NewPostManager.new(user,
                               raw: params[:body],
                               topic_id: params[:topic_id])
      result = manager.perform
  
    end
  
  end
  