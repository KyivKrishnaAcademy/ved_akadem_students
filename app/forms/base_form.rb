class BaseForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  private

  def add_model_errors(model)
    # TODO: replace with "errors.merge!(person.errors)" once upgraded to Rails 5.2.3
    model.errors.details.each do |attribute, attribute_details|
      attribute_details.each do |detail|
        errors.add(attribute, detail[:error])
      end
    end
  end
end
