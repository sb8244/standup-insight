class SlackApi
  def initialize(token:)
    @web_client = Slack::Web::Client.new(token: token)
  end

  def find_user_id(email:, username:)
    member = web_client.users_list.members.find do |member|
      next if member.is_bot
      member.name == username || member.profile.email == email
    end

    member.try!(:id)
  end

  private

  attr_reader :web_client
end
