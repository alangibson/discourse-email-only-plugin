
require 'rails_helper'

describe LonersController do

  fab!(:user) { Fabricate(:user) }

  describe "watch topic" do

    it 'subscribes user to topic using only email' do
      
      # Given
      SiteSetting.enable_staged_users = true

      # When
      post '/loners/watch' #, :params => { :email => "nobody@example.com" }
      html = Nokogiri::HTML5(response.body)

      # Then
      expect(response.content_type).to eq "text/html"

    end

  end

  context "reply to topic" do
  end

end