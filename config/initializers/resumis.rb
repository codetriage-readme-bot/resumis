module ResumisConfig
  DEFAULT_EXCLUDED_SUBDOMAINS = %w(
    mail auth api service login
    signup accounts account users
    ftp ldap webmail manage admin
  )

  # Sets the tenancy mode of the application. Possible values: :single, :multi
  def self.tenancy_mode
    ENV['RESUMIS_TENANCY_MODE'] ? ENV['RESUMIS_TENANCY_MODE'].to_sym : :single
  end

  def self.single_tenant?
    tenancy_mode == :single
  end

  def self.multi_tenant?
    tenancy_mode == :multi
  end

  def self.listing_enabled?
    ENV['RESUMIS_LISTING_ENABLED'].presence || true
  end

  # Used for ensuring authentication routes and such point to the right place
  def self.canonical_host
    ENV['RESUMIS_CANONICAL_HOST'].presence || '127.0.0.1.xip.io'
  end

  def self.excluded_subdomains
    if ENV['RESUMIS_EXCLUDED_SUBDOMAINS'].present?
      ENV['RESUMIS_EXCLUDED_SUBDOMAINS'].split(',')
    else
      DEFAULT_EXCLUDED_SUBDOMAINS
    end
  end

  def self.google_client_id
    ENV['RESUMIS_GOOGLE_CLIENT_ID']
  end
end
