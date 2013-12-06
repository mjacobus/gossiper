module Gossiper
  class Engine < ::Rails::Engine
    isolate_namespace Gossiper

    config.generators do |g|
      g.test_framework :rspec
      g.integration_tool :rspec
    end
  end
end
