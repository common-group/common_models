# frozen_string_literal: true

class SubProjectMachine
  include Statesman::Machine

  def self.basic_validation_states
    %i[online].freeze
  end

  def self.setup_machine
    state :draft, initial: true
    state :online
    state :deleted
    state :successful
    state :rejected

    # this block receive all transition
    # definitions
    yield self if block_given?

  end

  setup_machine do
    transition from: :deleted, to: %i[draft]
    transition from: :draft, to: %i[deleted online]
    transition from: :online, to: %i[draft deleted successful rejected]
  end

  def can_push_to_draft?
    can_transition_to? :draft
  end

  def can_push_to_trash?
    can_transition_to? :deleted
  end

  def can_push_to_online?
    can_transition_to? :online
  end

  # put project into deleted state
  def push_to_trash
    transition_to :deleted, to_state: 'deleted'
  end

  # put project into draft state
  def push_to_draft
    transition_to :draft, to_state: 'draft'
  end

  # put project in online state
  def push_to_online
    transition_to :online, to_state: 'online'
  end

  def finish
    transition_to(:successful, to_state: 'successful')
  end
end
