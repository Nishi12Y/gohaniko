import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"

// Chart.jsのコンポーネントを登録
Chart.register(...registerables)

// Connects to data-controller="chart"
export default class extends Controller {
  static values = {
    labels: Array,
    data: Array,
    color: String
  }

  connect() {
    // Canvas の描画コンテキスト取得
    const ctx = this.element.getContext("2d")

    // Chart.js インスタンス生成
    this.chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: this.labelsValue,
        datasets: [{
          label: "人数",
          data: this.dataValue,
          backgroundColor: this.colorValue || "rgba(248, 190, 102,0.9)",
          borderColor: this.colorValue || "rgba(248, 190, 102,1)",
          borderWidth: 2,
          borderRadius: 6
        }]
      },
      options: {
        scales: {
          y: {
            beginAtZero: true,
            ticks: { stepSize: 1 }
          }
        }
      }
    })
  }

  disconnect() {
    // Turboなどでページ遷移したときに壊れるのを防止
    if (this.chart) {
      this.chart.destroy()
    }
  }
}