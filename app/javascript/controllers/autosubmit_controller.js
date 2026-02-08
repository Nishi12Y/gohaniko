import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autosubmit"
export default class extends Controller {
  submit(event) {
    const form = event.target.form
    if (!form) return
    form.requestSubmit()
  }
}
