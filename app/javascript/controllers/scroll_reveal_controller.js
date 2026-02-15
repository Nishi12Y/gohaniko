import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    threshold: { type: Number, default: 0.15 }
  }

  connect() {
    this.observer = new IntersectionObserver(
      this.reveal.bind(this),
      {
        threshold: this.thresholdValue
      }
    )

    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  reveal(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        this.element.classList.add("is-visible")
        this.observer.unobserve(this.element) // 1回だけ
      }
    })
  }
}