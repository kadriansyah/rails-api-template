class Admin::CoreUserSerializer < ActiveModel::Serializer
    attributes :id, :email, :username, :partner

    attribute :id do
        object.id.to_s
    end

    def partner
        Admin::PartnerSerializer.new(Admin::CoreUser.find(instance_options[:id])).attributes
    end
end
