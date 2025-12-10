import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy"
export default class extends Controller {
  static values = { url: String }
  connect() {
    this.copyBtn = document.getElementById("copyButton")
    this.flashMessage = document.getElementById("flash-message")
  }
  copy() {
    navigator.clipboard.writeText(this.urlValue).then(() => {
      const originalHTML = this.copyBtn.innerHTML

      this.copyBtn.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-success" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
        </svg>
      `

      this.flashMessage.classList.remove("hidden")

      setTimeout(() => {
        this.flashMessage.classList.add("hidden")
      }, 3000)

      setTimeout(() => {
        this.copyBtn.innerHTML = originalHTML
      }, 1500)
    })
  }
}
