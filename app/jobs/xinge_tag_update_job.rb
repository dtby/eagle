class XingeTagUpdateJob < ActiveJob::Base
  queue_as :message

  def perform user_id
    # Do something later
    logger.info "XingeTagUpdateJob process start #{user_id}"

    config = Rails.configuration.database_configuration
    ActiveRecord::Base.establish_connection config["#{Rails.env}"]

    user = User.find_by id: user_id
    return unless user.present?

    user.update_room_tags
  end

end
