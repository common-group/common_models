module CommonModels
  class ProjectTransition < ActiveRecord::Base
    self.table_name = 'project_service.project_transitions'

    belongs_to :project, inverse_of: :project_transitions
    validates :to_state, inclusion: { in: FlexProjectMachine.states }

    belongs_to :order, inverse_of: :project_transitions
  end
end
