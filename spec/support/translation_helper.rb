module TranslationHelper
  def errors_on(model, attribute)
    I18n.t("activerecord.errors.models.#{model}.attributes.#{attribute}")
  end
end
