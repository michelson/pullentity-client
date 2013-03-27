require 'session'
#require "debugger"
module Pullentity
  module Client
    module Generate
      class Auth < Thor

        include ::Pullentity::Client::Utils

        no_tasks {

          def domain
            "http://pullentity.com"
            #"http://pullentity.dev:3000"
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
            password = ask("write your password: ", :magenta, :password => true )
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

          def check_for_yaml
            begin
              hsh = YAML.load_file(location + "pullentity.yml")
              @token      = hsh["auth_token"]
              @site       = hsh["site"]
              @theme_name = hsh["theme_name"]
              if hsh["auth_token"].empty?
                say "Error, the auth_token is empty", :red
                say "run: pullentity login" , :yellow
              end
            rescue => e
              say "Error, make sure you are inside a pullentity project", :red
              say "and pullentity.yml file is created" , :red
              raise
            end
          end

          def write_site_in_yaml(site)
            begin
              hsh = YAML.load_file(location + "pullentity.yml")
            rescue => e
              say "Error, make sure you are inside a pullentity project", :red
              say "and pullentity.yml file is created" , :red
              raise
            end
             hsh["site"] = site
             File.open("#{location}/pullentity.yml", "w"){|f| YAML.dump(hsh, f)}
          end

          def site_api_call(path)
            check_for_yaml
            uri = URI.parse("#{domain}#{path}?auth_token=#{@token}")
            http = Net::HTTP.new(uri.host, uri.port)
            request = Net::HTTP::Get.new(uri.request_uri)
            response = http.request(request)
            @json_body  = JSON.parse(response.body)
          end

          def export_api_call()
            check_for_yaml

            conn = Faraday.new(:url => domain) do |f|
              f.request :multipart
              f.request  :url_encoded             # form-encode POST params
              #f.response :logger                  # log requests to STDOUT
              f.adapter  Faraday.default_adapter  # make requests with Net::HTTP
            end

            payload = { :theme => Faraday::UploadIO.new("#{location}/pullentity_build.json", 'text/json') }
            response = conn.put("/api/v1/import_theme?auth_token=#{@token}&subdomain=#{@site}&theme_name=#{@theme_name}", payload )
            @json_body  = JSON.parse(response.body)
            say "#{@json_body[:status]} #{@json_body[:message]}", :green
          end

          def get_site_activated_theme_data
            site_api_call("/api/v1/sites/#{@site}.json")
          end

          def get_site_theme_data
            site_api_call("/api/v1/sites/#{@site}/themes/#{@theme_name}.json")
          end

          def prompt_for_site_select
            site_api_call("/api/v1/sites.json")
            count = 0
            arr = {}
            @json_body.each do |site|
              count += 1
              arr[count] = site
              say "[#{count}] Site: #{site["name"]}", :white
            end
            selector(arr)
          end

          def selector(arr)
            answer = ask "select the site", :yellow
            if arr[answer.to_i]
              write_site_in_yaml(arr[answer.to_i]["subdomain"])
              say "you have selected #{arr[answer.to_i]["name"]}", :green
              say "we configure site name in pullentity.yml", :green
            else
              say "plase select one on the list" , :red
              selector(arr)
            end
          end

          def get_sites
            site_api_call("/api/v1/sites.json")
            @json_body.each do |site|
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

        desc "select site", ""
        def select_site
          prompt_for_site_select
        end

        desc "export theme site", ""
        def export(name)
          say "exporting current theme...", :green
          export_api_call
        end



      end
    end
  end
end
