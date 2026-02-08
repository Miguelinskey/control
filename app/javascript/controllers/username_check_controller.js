import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "feedback"]
  static values = { url: String }

  connect() {
    this.timeout = null
  }

  disconnect() {
    if (this.timeout) clearTimeout(this.timeout)
  }

  check() {
    if (this.timeout) clearTimeout(this.timeout)

    const username = this.inputTarget.value.trim()

    if (username.length < 2) {
      this.feedbackTarget.textContent = ""
      this.feedbackTarget.className = "username-feedback"
      return
    }

    this.timeout = setTimeout(() => {
      this.performCheck(username)
    }, 400)
  }

  async performCheck(username) {
    try {
      const url = `${this.urlValue}?username=${encodeURIComponent(username)}`
      const response = await fetch(url, {
        headers: { "Accept": "application/json" }
      })
      const data = await response.json()

      this.feedbackTarget.textContent = data.message
      if (data.available) {
        this.feedbackTarget.className = "username-feedback username-available"
      } else {
        this.feedbackTarget.className = "username-feedback username-taken"
      }
    } catch {
      this.feedbackTarget.textContent = ""
      this.feedbackTarget.className = "username-feedback"
    }
  }
}
