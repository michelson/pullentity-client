require 'session'
require "debugger"
module Pullentity
  module Client
    module Generate
      class Auth < Thor

        include ::Pullentity::Client::Utils

        no_tasks {

          def domain
            "http://pullentity.dev:3000"
          end

          def login(email)
            begin
              hsh = YAML.load_file(location + "pullentity.yml")
            rescue => e
              say "Error, make sure you are inside a pullentity project", :red
              say "and pullentity.yml file is created" , :red
              raise
            end
            say("In order to retreive your authentication token we need your pullentity password", :yellow)
            password = ask("write your password: ", :magenta )
            uri = URI.parse("#{domain}/api/v1/login.json")
            http = Net::HTTP.new(uri.host, uri.port)
            request = Net::HTTP::Post.new(uri.request_uri)
            request.set_form_data({"email" => email, "password" => password  })
            response = http.request(request)

            json_body = JSON.parse(response.body)
            if json_body["status"] && json_body["status"] == "success"
              say "Congratz!, Your token is:"
              say json_body["auth_token"], :green
              say "we saved it in pullentity.yml", :green
              hsh["auth_token"] = json_body["auth_token"]
              File.open("#{location}/pullentity.yml", "w"){|f| YAML.dump(hsh, f)}
            else
              say response.body,  :red
            end
          end

          def site_api_call
            begin
              hsh = YAML.load_file(location + "pullentity.yml")
              token = hsh["auth_token"]
            rescue => e
              say "Error, make sure you are inside a pullentity project", :red
              say "and pullentity.yml file is created" , :red
              raise
            end
            uri = URI.parse("#{domain}/api/v1/sites.json?auth_token=#{token}")
            http = Net::HTTP.new(uri.host, uri.port)
            request = Net::HTTP::Get.new(uri.request_uri)
            response = http.request(request)
            json_body  = JSON.parse(response.body)
          end

          def get_sites
            site_api_call
            json_body.each do |site|
              say "Site ID: ##{site["id"]}", :white
              say " Name: " + site["name"].to_s, :green
              say " Domain: " + site["keywords"].to_s, :green
              say " Custom domain: " + site["custom_domain"].to_s, :green
              say " Subdomain: " + site["subdomain"].to_s, :green
              say " Activated: " + site["activated"].to_s, :green
            end
          end

          def location
            base_location
          end


          def source_root
            File.dirname(__FILE__)
          end

        }

        #map %(n) => 'login'
        desc "auth login <email> ", "login and configures auth_token."
        long_desc "login and configures auth_token"
        def set_login(email)
          login(email)
        end

        desc "list sites", ""
        def list_sites
          get_sites
        end



      end
    end
  end
end
