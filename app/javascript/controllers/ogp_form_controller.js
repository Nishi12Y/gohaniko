import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["url", "name", "address"]

  async fetchOgp() {
    const raw = this.urlTarget.value
    const normalized = this.normalizeUrl(raw)

    if (!normalized) return

    // ★ここで先にinputを書き換える
    this.urlTarget.value = normalized

    try {
      const res = await fetch(`/api/ogp?url=${encodeURIComponent(this.urlTarget.value)}`)
      const data = await res.json()
      if (data.error) return

      this.fillFields(data)
    } catch (e) {
      console.error("OGP fetch failed", e)
    }
  }

  fillFields(data) {
    // 店舗名：title をそのまま or 軽く加工
    if (!this.nameTarget.value && data.title) {
      this.nameTarget.value = this.normalizeTitle(data.title)
    }

    // 住所：description から推測（後述）
    // if (!this.addressTarget.value && data.description) {
    //   this.addressTarget.value = this.extractAddress(data.description)
    // }
  }

  normalizeTitle(title) {
    // 例: "オステリア・エッコ (経堂/イタリアン) | 食べログ"
    return title.split("|")[0].trim()
  }

  extractAddress(description) {
    // とりあえずそのまま（後で改善）
    return description
  }

  normalizeUrl(input) {
    if (!input) return ""

    // 1) http(s)以降だけ抜き出し（店名が前についててもOK）
    const m = input.match(/https?:\/\/\S+/)
    let url = m ? m[0] : input.trim()

    // 2) scheme補完
    if (!/^https?:\/\//i.test(url)) url = `https://${url}`

    // 3) ざっくり末尾の記号を落とす（コピペで付くことがある）
    url = url.replace(/[)\],.]+$/, "")

    return url
  }
}