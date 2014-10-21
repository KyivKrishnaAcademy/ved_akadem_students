require 'i18n/backend/fallbacks'
require 'i18n/backend/pluralization'

I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)

I18n.fallbacks.map(ru: :en)
I18n.fallbacks.map(uk: :en)
