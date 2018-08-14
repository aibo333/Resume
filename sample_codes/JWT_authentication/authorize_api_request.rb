module Authentication
    class AuthorizeApiRequest
        def initialize(jwt)
            @jwt = jwt
            @errors = {}
            @success = false
            if decoded_auth_token
                case role
                when "staff"
                    @success = true if provider_node.present? && staff.present? && !staff.try(:is_banned)
                when "customer"
                    @success = true if customer.present? && provider_node.present?  && !customer.try(:is_banned)
                else
                    @errors.deep_merge!({:role => ["invalid role"]})
                end
            end
        end

        def success?
            @success
        end

        def provider_node
            if decoded_auth_token
                node_identity = decoded_auth_token["provider_node_identity"]
                @provider_node ||= Node.find_by_identity(node_identity)
                if @provider_node.present?
                    @provider_node
                else
                    @errors.deep_merge!({:provider_node => ["not found"]})
                    nil
                end
            else
                nil
            end
        end

        def staff
            if provider_node
                staff_identity = decoded_auth_token["staff_identity"]
                @current_staff = @provider_node.staffs.find_by_identity(staff_identity)
                if @current_staff.present?
                    @errors.deep_merge!({:staff => ["banned"]}) if @current_staff.is_banned
                    @current_staff
                else
                    @errors.deep_merge!({:staff => ["not found"]})
                    nil
                end
            else
                nil
            end
        end

        def customer
            if decoded_auth_token
                case role
                when "provider"
                    nil
                when "customer"
                    customer_identity = decoded_auth_token["customer_identity"]
                    @customer ||= Customer.find_by_identity(customer_identity)
                    if @customer.present?
                        @errors.deep_merge!({:customer => ["banned"]}) if @customer.is_banned
                        @customer
                    else
                        @errors.deep_merge!({:customer => ["not found"]})
                        nil
                    end
                end
            else
                nil
            end
        end

        def role
            if decoded_auth_token
                if ["staff", "customer"].include?(decoded_auth_token["role"])
                    decoded_auth_token["role"]
                else
                    @errors.deep_merge!({:role => ["invalid role"]})
                    nil
                end
            end
        end

        def errors
            @errors
        end

        private

        attr_reader :headers

        def decoded_auth_token
            begin
                if @jwt.present?
                    hmac_secret = Rails.application.secrets.secret_key_base
                    @decoded_auth_token ||= JWT.decode(@jwt, hmac_secret, true, { :algorithm => 'HS256' }).first
                else
                    @errors.deep_merge!({
                        :token => ["must exist"]
                    })
                    nil
                end
            rescue JWT::VerificationError
                @errors.deep_merge!({
                    :token => ["Invalid token"]
                })
                nil
            rescue JWT::DecodeError
                @errors.deep_merge!({
                    :token => ["Incomplete token"]
                })
                nil
            end
        end
    end
end
