require 'digest/md5'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :projects
  has_many :resumes
  has_many :work_experiences
  has_many :education_experiences
  has_many :skills
  has_many :user_types
  has_many :types, through: :user_types

  accepts_nested_attributes_for :user_types, :allow_destroy => true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :subdomain, presence: Rails.application.config.x.resumis.tenancy_mode == :multi,
                        uniqueness: true,
                        case_sensitive: false,
                        exclusion: { in: %w(mail auth api service login signup accounts account users ftp ldap webmail),
                                     message: "%{value} is reserved." }

  nilify_blanks :only => [:domain]

  mount_uploader :header_image, HeaderImageUploader

  def developer?
    types.exists?(slug: 'developer')
  end

  def filmmaker?
    types.exists?(slug: 'filmmaker')
  end

  def musician?
    types.exists?(slug: 'musician')
  end

  def writer?
    types.exists?(slug: 'writer')
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def gravatar_url
		hash = Digest::MD5.hexdigest(email)

		"https://www.gravatar.com/avatar/#{hash}?s=256"
  end

  def copyright_range
    current_year = DateTime.now.year

    if created_at.year != current_year
      "#{created_at.year}-#{current_year} #{full_name}"
    else
      "#{current_year} #{full_name}"
    end
  end

  def social_networks
    networks = []

    networks << { network: 'github', username: github_handle, url: "https://github.com/#{github_handle}" } if github_handle.present?
    networks << { network: 'googleplus', username: googleplus_handle, url: "https://plus.google.com/#{googleplus_handle}"} if googleplus_handle.present?
    networks << { network: 'linkedin', username: linkedin_handle, url: "http://www.linkedin.com/in/#{linkedin_handle}/" } if linkedin_handle.present?
    networks << { network: 'soundcloud', username: soundcloud_handle, url: "https://soundcloud.com/#{soundcloud_handle}" } if soundcloud_handle.present?
    networks << { network: 'tumblr', username: nil, url: tumblr_url } if tumblr_url.present?
    networks << { network: 'twitter', username: twitter_handle, url: "https://twitter.com/#{twitter_handle}" } if twitter_handle.present?
    networks << { network: 'vimeo', username: vimeo_handle, url: "http://vimeo.com/#{vimeo_handle}" } if vimeo_handle.present?
    networks << { network: 'youtube', username: youtube_handle, url: "https://youtube.com/user/#{youtube_handle}"} if youtube_handle.present?

    networks
  end
end
