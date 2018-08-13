require 'active_record'
require 'pg'
require 'logger'
require 'common_models/config'
require 'common_models/state_machine/flex_project_machine'
require 'common_models/state_machine/aon_project_machine'
require 'common_models/state_machine/sub_project_machine'
require 'common_models/models/platform'
require 'common_models/models/user'
require 'common_models/models/project'
require 'common_models/models/flexible_project'
require 'common_models/models/subscription_project'
require 'common_models/models/project_transition'
require 'common_models/models/goal'
require 'common_models/models/report'
require 'common_models/models/reward'
require 'common_models/models/subscription'
require 'common_models/models/notification'
require 'common_models/models/catalog_payment'
require 'common_models/models/shipping_fee'
require 'common_models/models/address'
require 'common_models/models/origin'
require 'common_models/models/contribution'
require 'common_models/models/platform_api_key'
require 'common_models/models/temp_login_api_key'
require 'common_models/models/user_api_key'


module CommonModels
  def self.extended(obj)
    Statesman.configure do
      storage_adapter(Statesman::Adapters::ActiveRecord)
    end
    ActiveRecord::Base.logger = Logger.new('debug.log')
    config = ENV['DATABASE_URL'].presence || @config
    ActiveRecord::Base.establish_connection(config)
  end
end
