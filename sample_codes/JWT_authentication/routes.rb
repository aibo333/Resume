Rails.application.routes.draw do
    scope :path => '', :module => "api", :as => 'api' do
        namespace :v1 do
            # NOTE: Issue JWT token api
            post 'authenticate/(:node_identity)' => 'authenticator#authenticate', :as => 'authenticate'
            get 'authorize' => 'authenticator#authorize', :as => 'authorize'
            get 'captcha' => 'authenticator#captcha', :as => 'captcha'

            # api_v1_authenticate POST /v1/authenticate(/:node_identity)(.:format)    api/v1/authenticator#authenticate
            # api_v1_authorize GET  /v1/authorize(.:format)                           api/v1/authenticator#authorize
            # api_v1_captcha GET  /v1/captcha(.:format)                               api/v1/authenticator#captcha
        end
    end
end
