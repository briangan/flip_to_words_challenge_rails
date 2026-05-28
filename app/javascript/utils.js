// Utility functions for the application

export function resetPositionCheckboxes() {
  const checkboxes = document.querySelectorAll('.letter-position-checkbox');
  checkboxes.forEach(checkbox => {
    checkbox.checked = false;
  });
}

// Add more utility functions here as needed
