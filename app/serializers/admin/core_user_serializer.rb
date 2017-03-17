class Admin::CoreUserSerializer < ActiveModel::Serializer
    attributes :id, :email, :username

    attribute :id do
        object.id.to_s
    end
end
