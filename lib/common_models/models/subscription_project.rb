# frozen_string_literal: true

module CommonModels
  class SubscriptionProject < Project
    has_many :subscriptions
    has_many :catalog_payments, through: :subscriptions
    # delegate reusable methods from state_machine
    delegate :push_to_online, :push_to_draft, :finish,
            :push_to_trash, to: :state_machine

    def self.sti_name
      'sub'
    end

    # instace of a subscription project state machine
    def state_machine
      @state_machine ||= SubProjectMachine.new(self, {
                                               transition_class: CommonModels::ProjectTransition,
                                               association_name: :project_transitions
                                                })
    end
  end
end
