// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap.min"
import { resetPositionCheckboxes } from "utils"

// Make utilities available globally if needed
window.resetPositionCheckboxes = resetPositionCheckboxes;
