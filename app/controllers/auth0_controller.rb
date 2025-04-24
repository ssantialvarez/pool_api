require "uri"
require "net/http"

class Auth0Controller < ApplicationController
  def register
    # Called by /auth/callback endpoint
    # checks if the player already exists in the database
    # if not, creates a new player with the data from Auth0
    # params = { "sub" => payload["sub"], "name" => payload["name"], "picture" => payload["picture"] }
    player = Player.find_or_initialize_by(
      auth0_id: params[:sub]
    )
    # if the player is persisted it means that the player already exists in the database
    if !player.persisted?
      player.name = params[:name]
      player.profile_picture_url = params[:picture]
      player.save
    end
  end
  # Called by /authorization endpoint after login
  # checks if the authorization code exists and asks for access token to Auth0 Tenant
  # redirects to /dashboard
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
        redirect_uri: AUTH0_CONFIG["auth0_callback_url"],
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
    params = { "sub" => payload["sub"], "name" => payload["name"], "picture" => payload["picture"] }
    Net::HTTP.post_form(URI.parse("#{request.base_url}/auth/register"), params)


    # i want to redirect if env domain is given, if not localhost
    # i want to redirect to localhost:8080/dashboard?access_token=token
    domain = ENV["DOMAIN"] ? ENV["DOMAIN"] : "http://localhost:8080"
    redirect_to "#{domain}/dashboard?access_token=#{parsed_response["access_token"]}"
  end
end
