module ApplicationHelper
    def render_json_partial(model)
        previous_formats = lookup_context.formats
        lookup_context.formats = [:json]
        result = JbuilderTemplate.new(self) do |json|
            json.partial! model #model.to_partial_path, model.class.to_s.underscore.to_sym => model
        end.attributes!
        lookup_context.formats = previous_formats
        result
    end
end
