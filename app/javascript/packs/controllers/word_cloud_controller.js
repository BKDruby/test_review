import { Controller } from "stimulus"
import WordCloud from "wordcloud"

export default class extends Controller {
    static targets = ["output"]

    connect() {
        this.renderWordCloud()
    }

    renderWordCloud() {
        const wordData = this.data.get("words") || "[]"
        const words = JSON.parse(wordData)
        console.log(words);
        const wordArray = words.map(wordObj => ([
            wordObj.word,
            wordObj.count
        ]))

        WordCloud(this.outputTarget, {
            list: wordArray,
            gridSize: 18,
            weightFactor: 3,
            fontFamily: "Times, serif",
            color: 'random-light',
            backgroundColor: '#f0f0f0'
        })
    }
}
