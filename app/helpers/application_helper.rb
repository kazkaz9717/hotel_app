module ApplicationHelper
  def room_image_tag(room, options = {})
    if room.room_image.attached?
      image_tag room.room_image, options
    else
      image_tag "default_room.png", options
    end
  end

  def icon_image_tag(user, options = {})
    if user.icon_image.attached?
      image_tag user.icon_image, options
    else
      image_tag "default_icon.png", options
    end
  end
end