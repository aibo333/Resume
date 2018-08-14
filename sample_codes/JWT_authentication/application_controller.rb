class Api::V1::Provider::ApplicationController < Api::V1::ApplicationController
    before_action :authorize
    def authorize
        if request.headers["Authorization"].present? || params[:authorization].present?
            auth = Authentication::AuthorizeApiRequest.new(request.headers["Authorization"] || params[:authorization])
            if auth.success?
                @role = auth.role
                @current_staff = auth.staff
                @provider_node = auth.provider_node
            else
                render :json => {
                    :status => "failure",
                    :errors => auth.errors
                }, :status => 401
            end
        else
            render :json => {
                :status => "failure",
                :errors => [I18n.t(:not_authorized, :scope => [:errors, :general])]
            }, :status => 401
        end
    end
end
