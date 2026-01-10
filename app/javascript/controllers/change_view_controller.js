// app/javascript/controllers/change_view_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["listView", "mapView", "listTab", "mapTab", "indicator"]

  connect() {
    // 初期位置を設定
    this.updateIndicator(this.listTabTarget)
  }

  showList() {
    // ビューの切り替え
    this.listViewTarget.classList.remove("hidden")
    this.mapViewTarget.classList.add("hidden")
    
    // インジケーターを移動
    this.updateIndicator(this.listTabTarget)
  }

  showMap() {
    // ビューの切り替え
    this.listViewTarget.classList.add("hidden")
    this.mapViewTarget.classList.remove("hidden")
    
    // インジケーターを移動
    this.updateIndicator(this.mapTabTarget)
  }

  updateIndicator(tab) {
    const tabRect = tab.getBoundingClientRect()
    const containerRect = tab.parentElement.getBoundingClientRect()
    const left = tabRect.left - containerRect.left
    const width = tabRect.width
    
    this.indicatorTarget.style.left = `${left}px`
    this.indicatorTarget.style.width = `${width}px`
  }
}