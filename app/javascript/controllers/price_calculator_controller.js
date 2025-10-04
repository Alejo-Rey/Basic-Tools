import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["price", "totalCost", "croquettesNeeded"]
  static values = {
    croquettes: Number
  }

  connect() {
    this.updateCost()
  }

  updateCost() {
    const price = parseFloat(this.priceTarget.value) || 0
    const croquettes = this.croquettesValue || 0
    const totalCost = price * croquettes

    if (this.hasTotalCostTarget) {
      this.totalCostTarget.textContent = this.formatNumber(totalCost) + " K"
    }
  }

  formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
  }
}
