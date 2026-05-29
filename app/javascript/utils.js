// Utility functions for the application

export function resetPositionCheckboxes(parentSelector) {
  var selector = parentSelector ? `${parentSelector} .letter-position-checkbox` : '.letter-position-checkbox';
  const checkboxes = document.querySelectorAll(selector);
  checkboxes.forEach(checkbox => {
    checkbox.checked = false;
  });
}

// Add more utility functions here as needed
