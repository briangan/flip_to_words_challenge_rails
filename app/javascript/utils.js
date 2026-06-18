// Utility functions for the admin FlyLetter Manager, but not needed for FlyToWords component itself

export function resetPositionCheckboxes(parentSelector) {
  var selector = parentSelector ? `${parentSelector} .letter-position-checkbox` : '.letter-position-checkbox';
  const checkboxes = document.querySelectorAll(selector);
  checkboxes.forEach(checkbox => {
    checkbox.checked = false;
  });
}

export function toggleMultivalueCheckbox(event) {
  const checkbox = event.target;
  const valueSet = checkbox.getAttribute('data-multiple-values') || "1"; // Default to 1
  const values = ['0'].concat( valueSet.split(',') ) // 0 is the default "unchecked" value, then cycle through provided values
  // console.log("Toggling checkbox with current value:", checkbox.value, "and possible values:", values);

  const currentValueIndex = values.indexOf(checkbox.value); // not found returns -1
  const nextValueIndex = (currentValueIndex + 1) % values.length; // Cycle to next index
  const nextValue = values[nextValueIndex]; // Cycle through values
  // console.log("  checked? ", checkbox.checked, "Current value index:", currentValueIndex, "Next index:", nextValueIndex, "= Next value:", nextValue);

  if (checkbox.checked) {
    // Checkbox was just checked
    checkbox.value = nextValue;
  } else {
    // Checkbox was just unchecked - reset to first value
    checkbox.value = nextValue;
    checkbox.checked = (nextValueIndex > 0 && currentValueIndex < values.length);
    //console.log("  now checked? ", checkbox.checked, "Reset value to:", checkbox.value);
  }
  /*
  Cases:
     1   1   2   3   4
    [ ] [x] [ ] [ ] [ ]
             ^   ^   ^ when previously, UI will uncheck these
  */
}