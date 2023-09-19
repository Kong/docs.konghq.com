$(document).ready(function () {
  const modal = document.querySelector("#modal");
  const modalOpen = document.querySelector("#modal-open");
  const modalClose = document.querySelector("#modal-close");
  const page = document.querySelector(".page");

  function toggleModal(force) {
    modal.classList.toggle("closed", force);
  }

  function openModal() {
    toggleModal(false);

    modal.removeAttribute("aria-hidden");
    page.setAttribute("aria-hiddden", true);
    modal.querySelector(".button").focus();
  }

  function closeModal() {
    toggleModal(true);

    modal.setAttribute("aria-hiddden", true);
    page.removeAttribute("aria-hidden");
  }

  function focusNextElement() {
    const focusableElements = Array.from(modal.querySelectorAll(".button"));
    focusableElements.push(modalClose);
    const numberOfFocusableElements = focusableElements.length;

    let focusedElement = modal.querySelector(":focus");
    let focusedElementIndex = focusableElements.indexOf(focusedElement);

    if (focusedElementIndex === numberOfFocusableElements -1) {
      focusableElements.at(0).focus();
    } else {
      focusableElements.at(focusedElementIndex + 1).focus();
    }
  }

  if (modal) {
    modal.addEventListener("keydown", function(e) {
      switch (e.which) {
        // Escape key
        case 27:
          e.preventDefault();
          modalClose.click();
          break;
        // Tab key
        case 9:
          e.preventDefault();
          focusNextElement();
          break;
      }
    });

    modalOpen.addEventListener("click", function(e) {
      e.stopPropagation();

      openModal();
    });

    const buttons = modal.querySelectorAll(".modal-close, .button")

    buttons.forEach(function(elem) {
      elem.addEventListener("click", function() {
        closeModal();
      });
    });
  }
});
