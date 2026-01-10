import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    shops: Array,
    apiKey: String,
  }

  connect() {
    // Google Maps API がまだ読み込まれていない場合はロードしてから初期化
    if (!window.google || !window.google.maps) {
      this.loadGoogleMaps().then(() => this.initMap())
      return
    }
    this.initMap()
  }

  loadGoogleMaps() {
    return new Promise((resolve, reject) => {
      if (document.getElementById("google-maps-js")) return resolve()

      const script = document.createElement("script")
      script.id = "google-maps-js"
      script.async = true
      script.defer = true
      script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}`
      script.onload = resolve
      script.onerror = reject
      document.head.appendChild(script)
    })
  }

  static targets = ["canvas"]

  initMap() {
    const shops = this.shopsValue || []
    const defaultCenter = { lat: 35.681236, lng: 139.767125 }

    // ★保持する（行クリックから使う）
    this.map = new google.maps.Map(this.canvasTarget, { center: defaultCenter, zoom: 13 })
    this.infoWindow = new google.maps.InfoWindow()
    this.markersById = {}
    this.shopsById = {}

    if (shops.length === 0) return

    const bounds = new google.maps.LatLngBounds()

    shops.forEach((s) => {
      const pos = { lat: s.lat, lng: s.lng }

      const marker = new google.maps.Marker({
        position: pos,
        map: this.map,
        title: s.name,
      })

      // ★shop.id で引けるように保存
      this.markersById[String(s.id)] = marker
      this.shopsById[String(s.id)] = s

      marker.addListener("click", () => this.openInfo(marker, s))

      bounds.extend(pos)
    })

    this.map.fitBounds(bounds)
  }

  // ★一覧行クリック用：data-google-map-id-param を受け取る
  focus(event) {
    event.preventDefault?.()
    event.stopPropagation?.()

    const id = String(event.params.id)
    const marker = this.markersById?.[id]
    const shop = this.shopsById?.[id]
    console.log("focus", { id, marker, shop })

    if (!marker || !shop) return

    console.log("openInfo")
    this.openInfo(marker, shop)
  }


  // リンク等クリックで行クリックを止めたい場合に使う
  stop(event) {
    event.stopPropagation()
  }

  openInfo(marker, s) {
    const html = `
      <div class="gm-iw">
        <button type="button" class="gm-iw__close" aria-label="閉じる">×</button>
        <div class="gm-iw__title">${this.escapeHtml(s.name)}</div>
        ${s.url ? `<div class="gm-iw__link"><a href="${s.url}" target="_blank" rel="noopener">リンクを開く</a></div>` : ""}
      </div>
    `
    this.infoWindow.setContent(html)
    this.infoWindow.open({ anchor: marker, map: this.map })

    // 自作の×で閉じる
    google.maps.event.addListenerOnce(this.infoWindow, "domready", () => {
      const btn = document.querySelector(".gm-iw__close")
      if (btn) btn.addEventListener("click", () => this.infoWindow.close())
    })
  }

  // 文字列を安全にする（XSS対策）
  escapeHtml(str) {
    return String(str).replace(/[&<>"']/g, (m) => ({
      "&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#039;"
    }[m]))
  }
}