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

  def format_post_body(body)
    # 1. Escape all HTML from user input (use CGI to get plain String, not SafeBuffer)
    safe = CGI.escapeHTML(body)

    # 2. Process [img]url[/img] tags (only https)
    safe.gsub!(/\[img\](https:\/\/[^\s<\[\]]+)\[\/img\]/i) do
      %(<img src="#{$1}" class="post-image" loading="lazy">)
    end

    # 3. Auto-link URLs (no HTML exists yet besides our img tags)
    linked = auto_link_urls(safe)

    # 4. Process [quote:username]text[/quote] blocks
    formatted = linked.gsub(/\[quote:(.+?)\](.+?)\[\/quote\]/m) do
      username = Regexp.last_match(1)
      quoted_text = Regexp.last_match(2).strip
      "<blockquote class=\"post-quote\"><cite>#{username} wrote:</cite>#{simple_format(quoted_text, {}, sanitize: false)}</blockquote>"
    end

    # 5. sanitize: false is safe here — all user content was escaped in step 1
    simple_format(formatted, {}, sanitize: false)
  end

  private

  def auto_link_urls(text)
    text.gsub(%r{(?<!=")https?://[^\s<"]+}) do |url|
      punctuation = url.slice!(/[.,;:!?)]+\z/)
      %(<a href="#{url}" target="_blank" rel="noopener noreferrer">#{url}</a>#{punctuation})
    end
  end
end
