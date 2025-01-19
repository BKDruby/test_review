import { Controller } from "stimulus"
import { Chart, registerables } from "chart.js"

Chart.register(...registerables)

export default class extends Controller {
    static targets = ["chart"]

    connect() {
        this.renderChart()
    }

    renderChart() {
        const reviewData = this.data.get("reviews") || "[]"
        const parsedData = JSON.parse(reviewData)

        const labels = parsedData.map(data => data.month)
        const counts = parsedData.map(data => data.count)

        new Chart(this.chartTarget, {
            type: "bar",
            data: {
                labels: labels,
                datasets: [
                    {
                        label: "Reviews per Month",
                        data: counts,
                        backgroundColor: "rgba(75, 192, 192, 0.2)",
                        borderColor: "rgba(75, 192, 192, 1)",
                        borderWidth: 1,
                    },
                ],
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                    },
                },
            },
        })
    }
}
