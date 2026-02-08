import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { username: String, body: String }

  insert() {
    const textarea = document.querySelector("textarea[name='post[body]']")
    if (!textarea) return

    // Strip existing quotes to prevent infinite nesting
    const cleanBody = this.bodyValue.replace(/\[quote:.+?\][\s\S]*?\[\/quote\]/g, "").trim()
    if (!cleanBody) return

    const quoted = `[quote:${this.usernameValue}]${cleanBody}[/quote]\n\n`
    textarea.value = quoted + textarea.value
    textarea.focus()
    textarea.scrollIntoView({ behavior: "smooth", block: "center" })
  }
}
