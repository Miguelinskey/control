module ApplicationHelper
  def identicon_tag(username)
    tag.span(
      "",
      data: {
        controller: "identicon",
        identicon_username_value: username
      },
      class: "identicon"
    )
  end
end
