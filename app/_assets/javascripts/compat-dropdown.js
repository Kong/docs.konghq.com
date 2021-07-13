
function toggleDropdown(){
    $("#dropdown-content").toggleClass("show");
}

function resetForm(){
    let productDropdown = $("#product-compat-dropdown");
    let versionDropdown = $("#version-compat-dropdown");

    productDropdown.val("0");
    versionDropdown.val("0");
}

function getFormValues () {
    let product = $("#product-compat-dropdown").find(":selected").text();
    let version = $("#version-compat-dropdown").find(":selected").text();

    console.log("The product is: " + product);
    console.log("The version is: " + version);
}

$(document).ready(function(){
    $("#product-compat-dropdown").on("change", function() {
        let product = $(this).val();
        console.log("A change in the selected text has been detected. The product selected is: " + product);
    });
})
