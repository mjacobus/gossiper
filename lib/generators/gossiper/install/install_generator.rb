class Gossiper::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_initializer
    template "initializer.rb", "config/initializers/gossiper.rb"
  end

  def copy_locale
    template "locale.en.yml", "config/locales/gossiper.en.yml"
  end
end
