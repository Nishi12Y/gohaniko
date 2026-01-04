import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { shops: Array 
, apiKey: String
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

  initMap() {
    const shops = this.shopsValue || []
    const defaultCenter = { lat: 35.681236, lng: 139.767125 }

    const map = new google.maps.Map(this.element, { center: defaultCenter, zoom: 13 })
    if (shops.length === 0) return

    const bounds = new google.maps.LatLngBounds()
    const infoWindow = new google.maps.InfoWindow()

    shops.forEach((s) => {
      const pos = { lat: s.lat, lng: s.lng }

      const marker = new google.maps.Marker({
        position: pos,
        map,
        title: s.name,
      })

      marker.addListener("click", () => {
        // 内容はHTMLでOK（必要なら住所やURLも入れられる）
        const html = `
          <div class="gm-iw">
            <button type="button" class="gm-iw__close" aria-label="閉じる">×</button>
            <div class="gm-iw__title">${this.escapeHtml(s.name)}</div>
            ${s.url ? `<div class="gm-iw__link"><a href="${s.url}" target="_blank" rel="noopener">リンクを開く</a></div>` : ""}
          </div>
        `
        infoWindow.setContent(html)
        infoWindow.open({ anchor: marker, map })

        // 自作の×で閉じる
        google.maps.event.addListenerOnce(infoWindow, "domready", () => {
          const btn = document.querySelector(".gm-iw__close")
          if (btn) btn.addEventListener("click", () => infoWindow.close())
        })
      })

      bounds.extend(pos)
    })

    map.fitBounds(bounds)
  }

  // 文字列を安全にする（XSS対策）
  escapeHtml(str) {
    return String(str).replace(/[&<>"']/g, (m) => ({
      "&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#039;"
    }[m]))
  }
}