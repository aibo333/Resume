module Authentication
    class Authenticate
        def initialize(username, password, node, role)
            @username = username
            @password = password
            @node = node
            @role = role
            @errors = {}
            @authenticated = false
            case role
            when "staff"
                @authenticated = true if provider_node.present? && staff.present?
            when "customer"
                @authenticated = true if customer.present? && provider_node.present?
            else
                @errors.deep_merge!({:role => ["invalid role"]})
            end
        end

        def token
            if authenticated?
                hmac_secret = Rails.application.secrets.secret_key_base
                JWT.encode(
                    {
                        :provider_node_identity => provider_node.try(:identity),
                        :customer_identity => customer.try(:identity),
                        :staff_identity => staff.try(:identity),
                        :role => @role
                    },
                    hmac_secret,
                    'HS256'
                )
            else
                nil
            end
        end

        def authenticated?
            @authenticated
        end

        def errors
            @errors
        end

        def provider_node
            if node.present? && node.try(:class) {|c| c == Node}
                case @role
                when "staff"
                    if node.identity.present?
                        node
                    else
                        @errors.deep_merge!({:provider_node => ["not found"]})
                        nil
                    end
                when "customer"
                    node
                end
            else
                @errors.deep_merge!({:provider_node => ["invalid node"]})
                nil
            end
        end

        private
        attr_reader :username, :password, :node

        def staff
            if provider_node
                staff = provider_node.staffs.find_by_username(username)
                return staff if staff && staff.authenticate(password)
                @errors.deep_merge!({:staff => ["incorrect username or password"]})
                nil
            else
                nil
            end
        end

        def customer
            if node.present? && node.try(:class) {|c| c == Node}
                case @role
                when "staff"
                    nil
                when "customer"
                    fetched_customer = node.customers.find_by_username(username)
                    if fetched_customer.present? && fetched_customer.authenticate(password)
                        fetched_customer
                    else
                        @errors.deep_merge!({:customer_node => ["incorrect username or password"]})
                        nil
                    end
                end
            else
                @errors.deep_merge!({:provider_node => ["invalid node"]})
                nil
            end
        end
    end
end
