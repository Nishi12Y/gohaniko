// app/javascript/controllers/date_picker_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "grid", "monthLabel", "hiddenContainer", "form"]

  connect() {
    this.current = new Date()
    this.selected = new Set()
    this.render()
  }

  open() { this.modalTarget.showModal() }
  close() { this.modalTarget.close() }

  prevMonth() {
    this.current.setMonth(this.current.getMonth() - 1)
    this.render()
  }

  nextMonth() {
    this.current.setMonth(this.current.getMonth() + 1)
    this.render()
  }

  toggle(dateStr) {
    if (this.selected.has(dateStr)) this.selected.delete(dateStr)
    else this.selected.add(dateStr)
    this.render()
  }

  submit() {
    if (this.selected.size === 0) {
      alert("候補日を選択してください")
      return
    }

    this.hiddenContainerTarget.innerHTML = ""

    // 送信するhiddenを生成
    this.selected.forEach((dateStr) => {
      const input = document.createElement("input")
      input.type = "hidden"
      input.name = "group_schedule_date[candidate_dates][]"
      input.value = dateStr // "YYYY-MM-DD"
      this.hiddenContainerTarget.appendChild(input)
    })

    this.formTarget.submit()
    this.close()
    this.selected.clear()
    this.render()
  }

  render() {
    const year = this.current.getFullYear()
    const monthIndex = this.current.getMonth() // 0-based

    this.monthLabelTarget.textContent = `${monthIndex + 1}月`

    const first = new Date(year, monthIndex, 1)
    const last = new Date(year, monthIndex + 1, 0)
    const firstDow = first.getDay()
    const daysInMonth = last.getDate()

    // グリッド初期化
    this.gridTarget.innerHTML = ""

    // 前月埋め
    const prevLast = new Date(year, monthIndex, 0).getDate()
    for (let i = firstDow - 1; i >= 0; i--) {
      this.gridTarget.appendChild(this.cell(prevLast - i, true, null))
    }

    // 当月
    for (let d = 1; d <= daysInMonth; d++) {
      const dateStr = this.formatDate(year, monthIndex + 1, d) // month 1-based
      this.gridTarget.appendChild(this.cell(d, false, dateStr))
    }

    // 次月埋め
    const totalCells = firstDow + daysInMonth
    const rem = 7 - (totalCells % 7)
    if (rem < 7) {
      for (let d = 1; d <= rem; d++) {
        this.gridTarget.appendChild(this.cell(d, true, null))
      }
    }
  }

  cell(day, disabled, dateStr) {
    const btn = document.createElement("button")
    btn.type = "button"
    btn.textContent = day
    btn.className = "aspect-square flex items-center justify-center rounded-lg text-sm transition-colors"

    if (disabled) {
      btn.className += " text-gray-300 cursor-default"
      btn.disabled = true
      return btn
    }

    const selected = this.selected.has(dateStr)
    btn.className += selected
      ? " bg-red-300 text-white hover:bg-red-400"
      : " hover:bg-gray-100 cursor-pointer"

    btn.addEventListener("click", () => this.toggle(dateStr))
    return btn
  }

  formatDate(y, m, d) {
    const yy = String(y).padStart(4, "0")
    const mm = String(m).padStart(2, "0")
    const dd = String(d).padStart(2, "0")
    return `${yy}-${mm}-${dd}`
  }
}