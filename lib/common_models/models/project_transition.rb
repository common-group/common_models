module CommonModels
  class ProjectTransition < ActiveRecord::Base
    self.table_name = 'project_service.project_transitions'
    include Statesman::Adapters::ActiveRecordTransition

    belongs_to :project, inverse_of: :project_transitions
  end
end
