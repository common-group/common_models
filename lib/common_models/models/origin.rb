module CommonModels
  class Origin < ActiveRecord::Base
    self.table_name = 'analytics_service.origins'
    belongs_to :platform
    has_many :projects
    has_many :contributions

    validates :domain, presence: true
    validates :domain, uniqueness: { scope: :referral }

    # Process a given ref and http referrer
    # until found or create a new Origin
    # { ref: referral, domain: 'domain' }
    def self.process_hash(hash = {}, platform)
      if hash[:domain].present?
        find_or_create_by(
          platform: platform,
          referral: hash[:ref],
          domain: get_domain_from_url(hash[:domain])
        )
      end
    end

    protected

    def self.get_domain_from_url(url)
      uri = URI.parse(url)
      uri = URI.parse("http://#{url}") if uri.scheme.nil?
      host = uri.host.downcase
      host.start_with?('www.') ? host[4..-1] : host
    end
  end
end
