module CommonModels
  class Project < ActiveRecord::Base
    include Statesman::Adapters::ActiveRecordQueries
    FIELDS = [:goal, :headline, :video_url, :created_at, :updated_at, :about_html, :recommended, :video_thumbnail, :status, :online_days, :more_links, :uploaded_image, :video_embed_url, :audited_user_name, :audited_user_cpf, :audited_user_moip_login, :audited_user_phone_number, :traffic_sources, :budget, :full_text_index, :budget_html, :expires_at, :city_id, :origin_id, :service_fee, :total_installments, :tracker_snippet_html, :ip_address, :published_ip, :skip_finish, :admin_notes, :cover_image, :common_id]
    HEADLINE_MAXLENGTH = 100
    PUBLISHED_STATES = %w[online waiting_funds successful failed].freeze

    self.table_name = 'project_service.projects'
    self.inheritance_column = 'mode'
    store_accessor :data, FIELDS
    belongs_to :user
    belongs_to :platform
    has_many :goals, foreign_key: :project_id
    has_many :reports, foreign_key: :project_id
    has_many :contributions, foreign_key: :project_id
    has_many :project_transitions, autosave: false

    validates_presence_of :name, :user, :service_fee
    validates_length_of :headline, maximum: HEADLINE_MAXLENGTH
    validates_numericality_of :goal, greater_than: 9, allow_blank: true
    validates_numericality_of :service_fee, greater_than: 0, less_than_or_equal_to: 1
    validates_uniqueness_of :permalink, case_sensitive: false
    validates_format_of :permalink, with: /\A(\w|-)*\Z/
    validates_presence_of :permalink, allow_nil: true


    def self.find_sti_class(type_name)
      case type_name
      when 'flex'
        CommonModels::FlexibleProject
      when 'sub'
        CommonModels::SubscriptionProject
      else
        CommonModels::Project
      end
    end

    def state
      status
    end

    def paid_pledged
      paid_pledged ||= contributions.is_confirmed.sum(:value)
    end

    def reached_goal?
      paid_pledged >= goal
    end

    delegate :push_to_draft, :reject, :push_to_online, :fake_push_to_online, :finish, :push_to_trash,
             :can_transition_to?, :transition_to, :can_reject?, :can_push_to_trash?,
             :can_push_to_online?, :can_push_to_draft?, to: :state_machine

    # Init all or nothing machine
    def state_machine
      @state_machine ||= CommonModels::AonProjectMachine.new(self, {
                                               transition_class: CommonModels::ProjectTransition
                                             })
    end

    %w[
    draft rejected online successful waiting_funds
    deleted failed
  ].each do |st|
      define_method "#{st}?" do
        if status.nil?
          state_machine.current_state == st
        else
          status == st
        end
      end
    end
  end
end
