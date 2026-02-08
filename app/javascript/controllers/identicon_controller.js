import { Controller } from "@hotwired/stimulus"
import { minidenticon } from "minidenticons"

export default class extends Controller {
  static values = { username: String }

  connect() {
    const svgContent = minidenticon(this.usernameValue)
    this.element.innerHTML = `<svg viewBox="0 0 5 5">${svgContent}</svg>`
  }
}
