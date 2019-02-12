module Markazuna
    module CommonModel
        def as_json(options={})
            json = super(:except => :_id)
            json.merge('id' => self.id.to_s)
        end
    end
end