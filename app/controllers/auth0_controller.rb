require "uri"
require "net/http"

class Auth0Controller < ApplicationController
  def register
    player = Player.new do |p|
      p.auth0_id = params[:sub]
      p.name = params[:name]
      p.profile_picture_url = params[:picture]
    end

    player.save
  end

  def callback
    code = params[:code]
    if code != nil
      url = URI("https://#{AUTH0_CONFIG["auth0_domain"]}/oauth/token")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request["Accept"] = "application/json"

      request.body = URI.encode_www_form(
        redirect_uri: "http://localhost:3000/auth/callback",
        client_id: AUTH0_CONFIG["auth0_client_id"],
        client_secret: AUTH0_CONFIG["auth0_client_secret"],
        grant_type: "authorization_code",
        code: code
      )

      response = https.request(request)

      if response.is_a?(Net::HTTPSuccess)
        parsed_response = JSON.parse(response.body)
      else
        parsed_response = {
          error: "Error: #{response.code} - #{response.message}",
          body: response.body
        }
      end
    else
      parsed_response = "No access token."
    end
    id_token = parsed_response["id_token"]
    decoded_token = JWT.decode(id_token, nil, false) # false = does not verify firm

    payload = decoded_token[0]
    auth0_id = payload["sub"]


    player = Player.find_by(auth0_id: auth0_id)
    if player == nil
      params = { "sub" => payload["sub"], "name" => payload["name"], "picture" => payload["picture"] }
      Net::HTTP.post_form(URI.parse("http://localhost:3000/auth/register"), params)
    end


    redirect_to "http://localhost:8080/dashboard?access_token=#{parsed_response["access_token"]}"
  end
end
