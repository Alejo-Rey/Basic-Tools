import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["price", "resourceSelect", "message", "messageContent"]
  static values = {
    resourcePrices: Object
  }

  updateResourcePrice(event) {
    const resourceId = event.target.value
    const price = this.resourcePricesValue[resourceId] || 0

    if (this.hasPriceTarget) {
      this.priceTarget.value = price
    }

    // Hide message when changing resource
    this.hideMessage()
  }

  async updateResourcePriceInDB(event) {
    event.preventDefault()

    const resourceId = this.resourceSelectTarget.value
    const newPrice = this.priceTarget.value
    const locale = document.documentElement.lang || 'en'

    if (!newPrice || newPrice <= 0) {
      this.showMessage('Please enter a valid price', 'error')
      return
    }

    const button = event.currentTarget
    const originalHTML = button.innerHTML
    button.disabled = true
    button.innerHTML = '<svg class="w-5 h-5 animate-spin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>'

    try {
      const response = await fetch(`/${locale}/resources/${resourceId}/update_price`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ price: newPrice })
      })

      const data = await response.json()

      if (data.success) {
        // Update the cached prices
        this.resourcePricesValue[resourceId] = parseInt(newPrice)
        this.showMessage(data.message, 'success')
      } else {
        this.showMessage(data.message, 'error')
      }
    } catch (error) {
      this.showMessage('Error updating price: ' + error.message, 'error')
    } finally {
      button.disabled = false
      button.innerHTML = originalHTML
    }
  }

  showMessage(text, type) {
    if (this.hasMessageTarget && this.hasMessageContentTarget) {
      this.messageContentTarget.textContent = text

      // Remove old classes
      this.messageContentTarget.className = 'px-4 py-3 rounded-lg border-2 text-center font-semibold shadow-md transition-all'

      // Add new classes based on type
      if (type === 'success') {
        this.messageContentTarget.classList.add('bg-blue-light', 'border-blue', 'text-wood-dark')
      } else {
        this.messageContentTarget.classList.add('bg-orange-light', 'border-orange', 'text-wood-dark')
      }

      this.messageTarget.classList.remove('hidden')

      // Auto-hide after 5 seconds
      setTimeout(() => this.hideMessage(), 5000)
    }
  }

  hideMessage() {
    if (this.hasMessageTarget) {
      this.messageTarget.classList.add('hidden')
    }
  }
}
