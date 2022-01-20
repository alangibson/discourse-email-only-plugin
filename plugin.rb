# frozen_string_literal: true

# name: loners
# about: Watch and reply to topics using only your email
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0
# transpile_js: true

enabled_site_setting :loners_enabled

after_initialize do

    require_dependency File.expand_path('../app/loners_controller', __FILE__)

    Discourse::Application.routes.append do
        post '/loners/watch' => 'loners#watch'
        post '/loners/reply' => 'loners#reply'
    end

end
