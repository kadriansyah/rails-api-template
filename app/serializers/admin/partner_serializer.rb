class Admin::PartnerSerializer < ActiveModel::Serializer
    attributes :id, :firstname, :lastname

    attribute :id do
        object.id.to_s
    end
end
