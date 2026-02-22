import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    duration: { type: Number, default: 250 },
    stagger: { type: Number, default: 40 }, // 0,40,80...ms
  }

  connect() {
    // 初期状態を作ってから、少しずつEnterさせる
    this.element.classList.add("shop-card", "shop-card--enter")

    const idx = Number(this.element.dataset.index || 0)
    const delay = idx * this.staggerValue

    window.setTimeout(() => {
      // transition発火のために2段階
      requestAnimationFrame(() => {
        this.element.classList.add("shop-card--enter-active")
        this.element.classList.remove("shop-card--enter")

        window.setTimeout(() => {
          this.element.classList.remove("shop-card--enter-active")
        }, this.durationValue)
      })
    }, delay)
  }

  tap() {
    this.element.classList.add("shop-card--tap")
    window.setTimeout(() => {
      this.element.classList.remove("shop-card--tap")
    }, 120)
  }
}