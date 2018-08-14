class Api::V1::AuthenticatorController < Api::V1::ApplicationController
    before_action :set_node, :only => [:authenticate]
    before_action :verify_captcha, :only => [:authenticate]
    def authenticate
        auth = Authentication::Authenticate.new(params[:username], params[:password], @node, params[:role])
        if auth.authenticated?
            render :json => {
                :status => 'success',
                :token => auth.token,
                :node => auth.provider_node
            }
        else
            render json: {
                :status => 'failure',
                :errors => auth.errors,
            }
        end
    end

    def captcha
        render :json => {
            :status => "success",
            :captcha => Rails.env == "production" ? Captcha.generate(nil, true) : Captcha.generate("TEST")
            # :captcha => Captcha.generate
        }
    end

    def authorize
        auth = Authentication::AuthorizeApiRequest.new(request.headers["Authorization"] || params[:authorization])
        if auth.success?
            render :json => {
                :status => "success"
            }
        else
            render :json => {
                :status => "failure",
                :errors => auth.errors,
            }
        end
    end

    private

    def set_node
        if params[:node_identity].present?
            @node = Node.find_by_identity(params[:node_identity])
            raise_node_not_found unless @node.present?
        elsif request.headers[:Hostname].present?
            @node = Node.find_by_host(request.headers[:Hostname])
            raise_node_not_found unless @node.present?
        else
            raise_node_not_found
        end
    end

    def verify_captcha
        if params[:need_captcha]
            if params[:user_answer].present? && params[:encrypted_answer]
                key = Rails.application.secrets.secret_key_base
                crypt = ActiveSupport::MessageEncryptor.new(key)
                answer_object = JSON.parse(crypt.decrypt_and_verify(params[:encrypted_answer]))
                if answer_object["expired_at"] > Time.now
                    if answer_object["original_answer"].downcase != params[:user_answer].downcase
                        render :json => {
                            :status => "failure",
                            :errors => {
                                :captcha => ["captcha verification failed"]
                            }
                        }
                        false
                    end
                else
                    render :json => {
                        :status => "failure",
                        :errors => {
                            :captcha => ["captcha verification timeout"]
                        }
                    }
                    false
                end
            else
                render :json => {
                    :status => "failure",
                    :errors => {
                        :captcha => ["captcha verification failed"]
                    }
                }
                false
            end
        end
    end

    def raise_node_not_found
        render :json => {
            :status => "failure",
            :errors => {
                :node => ["not found"]
            }
        }, :status => 404
    end
end
