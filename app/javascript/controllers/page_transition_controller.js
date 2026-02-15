import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { duration: { type: Number, default: 250 } }

  connect() {
    // bodyに付ける前提
    this.element.classList.add("page-transition")

    this.beforeRender = this.beforeRender.bind(this)
    this.afterRender = this.afterRender.bind(this)

    document.addEventListener("turbo:before-render", this.beforeRender)
    document.addEventListener("turbo:render", this.afterRender)

    // 初回表示もふわっと入れたい場合
    this.playEnter()
  }

  disconnect() {
    document.removeEventListener("turbo:before-render", this.beforeRender)
    document.removeEventListener("turbo:render", this.afterRender)
  }

  beforeRender(event) {
    // Turboがサポートしていれば、差し替えを一時停止してアニメしてからresumeする
    const resume = event?.detail?.resume
    if (typeof resume !== "function") return

    event.preventDefault()

    this.playLeave(() => {
      resume()
    })
  }

  afterRender() {
    this.playEnter()
  }

  playEnter() {
    const el = this.element
    el.classList.remove("page-leave", "page-leave-active")

    el.classList.add("page-enter")
    // 次フレームでactive付与（transitionを確実に発火させる）
    requestAnimationFrame(() => {
      el.classList.add("page-enter-active")
      el.classList.remove("page-enter")
      window.setTimeout(() => {
        el.classList.remove("page-enter-active")
      }, this.durationValue)
    })
  }

  playLeave(done) {
    const el = this.element
    el.classList.remove("page-enter", "page-enter-active")

    el.classList.add("page-leave")
    requestAnimationFrame(() => {
      el.classList.add("page-leave-active")
      el.classList.remove("page-leave")
      window.setTimeout(() => {
        el.classList.remove("page-leave-active")
        done?.()
      }, this.durationValue)
    })
  }
}