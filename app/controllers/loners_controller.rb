require 'faker'
I18n.reload!

class LonersController < ApplicationController

    include RecaptchaVerifiable
    skip_before_action :verify_authenticity_token

    # Make sure there is a staged user in the db
    def ensure_user

      # TODO Is this safe? It allows anyone to post as a staged user if they know their email address.
      #      It may be emough to only allow users to post one time as a staged user
      #      then force them to register after that.

      # See if staged user exists
      user = User.where(staged: true).with_email(@email.strip.downcase).first
  
      # Create a staged user manually
      if !user

        # FIXME if user enters email that already exists for an active user, Rails returns 422 error when we save user
        #       ActiveRecord::RecordInvalid (Validation failed: Primary email has already been taken)
        # This does not happen here with a staged user becase we would never have entered this block

        user = User.new
        user.staged = true
        user.email = @email
        user.username = Faker::FunnyName.name.gsub(' ', '')[0...10] + SecureRandom.alphanumeric(4) + '_guest'
        user.active = false
        user.save!
      end
      
      user
    end
  
    # Watch topic as a staged user
    def watch
      Rails.logger.info 'Called LonersController#watch'
  
      result = TopicUser.change(@user, @topic_id, notification_level: @notification_level)
  
    end

    # Reply to topic as a staged user
    def reply
      Rails.logger.info 'Called LonersController#reply'
      Rails.logger.info @reply_body

      manager = NewPostManager.new(@user,
                               raw: @reply_body,
                               topic_id: @topic_id)
      manager.perform
    end

    def put
      Rails.logger.info 'Called LonersController#put'

      if SiteSetting.loners_captcha_enabled?
        if ! RecaptchaVerifier.verify(params[:watch][:content][:captcha_response].chomp, request.ip)
          render status: :unauthorized, json: { error: "Captcha verification failed" }
          return
        end
      end

      # Parse form data
      @email = params[:watch][:content][:email] # Required
      @reply_body = params[:watch][:content][:body] # Optional
      @topic_id = params[:watch][:content][:topic_id].to_i # Required
      @notification_level = params[:watch][:content][:notification_level].to_i # Required

      # Make sure we have a valid user object
      @user = ensure_user

      # Create a new post if there is a reply body
      if @reply_body
        reply
      end
      # and always watch
      watch

      render json: { }
    end
  
  end
  