class User < ApplicationRecord
  has_and_belongs_to_many :groups

  has_many :answers
  has_many :stand_ups, through: :groups
  has_many :slack_integrations
  has_many :slack_user_mappings

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:slack]

  def self.gets_email
    where(gets_email: true)
  end

  def display_name
    name || email
  end

  def slack_user_mapping_for(group:)
    slack_user_mappings.find_by(group: group)
  end
end
