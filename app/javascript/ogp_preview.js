document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[id^='ogp-preview-']").forEach(async (card) => {
    const id = card.id.replace("ogp-preview-", "");
    const url = card.dataset.url;

    if (!url) return;

    try {
      const res = await fetch(`/api/ogp?url=${encodeURIComponent(url)}`);
      const data = await res.json();

      if (data.error) return;

      document.getElementById(`ogp-image-${id}`).src = data.image;
      document.getElementById(`ogp-title-${id}`).innerText = data.title;
      document.getElementById(`ogp-description-${id}`).innerText = data.description;
    } catch (e) {
      console.error("OGP fetch failed", e);
    }
  });
});
