document.addEventListener("DOMContentLoaded", (event) => {
  const dropdown = document.getElementById('version-selector');

  if (dropdown !== null) {
    dropdown.addEventListener('change', (event) => {
      event.stopPropagation();

      let currentPath = window.location.pathname;
      let segments = currentPath.split('/');
      segments[2] = event.target.value;

      window.location.pathname = segments.join('/');
    });
  }
});
