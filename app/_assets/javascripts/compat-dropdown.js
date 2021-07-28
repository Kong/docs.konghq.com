function toggleDropdown() {
  $("#dropdown-content").toggleClass("show");
}

function resetForm() {
  let productDropdown = $("#product-compat-dropdown");
  let versionDropdown = $("#version-compat-dropdown");

  productDropdown.val("0");
  versionDropdown.val("0");

  $(".results-table").hide();
}

function getFormValues() {
  let product = $("#product-compat-dropdown").val();

  const versionDropdown = $("#version-compat-dropdown");
  let version = "";
  if (versionDropdown.is(":visible")) {
    version = versionDropdown.val().replace(/\./g, "_");
  }

  // Show the correct results table
  const productTable = $("#" + product + "-" + version);
  $(".results-table").hide();
  productTable.show();
}

$(document).ready(function () {

  $("#product-compat-dropdown")
    .on("change", function () {
      let productSelection = $(this).val();
      console.log(
        "A change in the selected text has been detected. The product selected is: " +
          productSelection
      );

      // Find the versions for this product
      let product;
      for (let p of window.productCompatibility) {
        if (p.slug === productSelection) {
          product = p;
          break;
        }
      }

      // If we don't have data for that product, stop execution
      if (!product) {
        return;
      }

      const versionDropdown = $("#version-compat-dropdown");
      const versionSelector = $("#version-selector");

      // Remove any existing versions from the dropdown
      versionDropdown.children().remove();

      // If the product has no versions, don't show the dropdown
      if (product.noversions) {
        versionSelector.hide();
        return;
      }

      // Otherwise add all the versions to the dropdown
      for (let v of product.versions) {
        versionDropdown.append(
          $("<option>", {
            text: v.release,
          })
        );
      }
      // Then show the dropdown
      versionSelector.show();
    })
    // Automatically trigger the change event to show the
    // list of valid versions for the first entry
    .trigger("change");
});
