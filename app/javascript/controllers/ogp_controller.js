import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ogp"
export default class extends Controller {
  connect() {
    document.querySelectorAll("[id^='ogp-preview-']").forEach(async (card) => {
      const id = card.id.replace("ogp-preview-", "");
      const url = card.dataset.url;

      if (!url) return;

      try {
        const res = await fetch(`/api/ogp?url=${encodeURIComponent(url)}`);
        const data = await res.json();

        if (data.error) return;

        // 画像セット
        const img = document.getElementById(`ogp-image-${id}`)
        img.src = data.image

        // 画像ロード完了後に切り替え
        img.onload = () => {
          img.classList.remove("hidden")
          document
            .getElementById(`ogp-loading-${id}`)
            ?.classList.add("hidden")
        }
        
        document.getElementById(`ogp-title-${id}`).innerText = data.title;
        document.getElementById(`ogp-description-${id}`).innerText = data.description;
      } catch (e) {
        console.error("OGP fetch failed", e);
      }
    });
  }
}
