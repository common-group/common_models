# frozen_string_literal: true

module CommonModels
  class FlexibleProject < Project
    FINAL_LAP_INTERVAL = 7

    # delegate reusable methods from state_machine
    delegate :push_to_online, :finish, :push_to_draft,
            :push_to_trash, :reject, to: :state_machine

    def self.sti_name
      'flex'
    end

    # instace of a flexible project state machine
    def state_machine
      @state_machine ||= FlexProjectMachine.new(self, {
                                                transition_class: CommonModels::ProjectTransition,
                                                association_name: :project_transitions
                                                })
    end
  end
end
