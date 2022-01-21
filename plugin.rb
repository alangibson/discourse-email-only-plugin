# frozen_string_literal: true

# name: discourse-loners
# about: Watch and reply to topics using only your email
# version: 0.0.1
# authors: Alan Gibson
# url: https://github.com/alangibson/discourse-loners
# required_version: 2.7.0
# transpile_js: true

# gem 'faker', '2.19.0', {require: false }

enabled_site_setting :loners_enabled

load File.expand_path('../lib/google_recaptcha.rb', __FILE__)
load File.expand_path('../services/recaptcha_verifier.rb', __FILE__)
load File.expand_path('../app/controllers/concerns/recaptcha_verifiable.rb', __FILE__)

after_initialize do

    load File.expand_path('../app/controllers/loners_controller.rb', __FILE__)

    Discourse::Application.routes.append do
        post '/loners/watch' => 'loners#watch'
        post '/loners/reply' => 'loners#reply'
        put '/loners/:request_id' => 'loners#put'
        put '/watchs/:request_id' => 'loners#put'

        match '/grverify' => 'recaptcha#index', :via => :post
    end

end
