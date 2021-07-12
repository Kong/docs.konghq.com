
// from nav-v2.html

function handleSearchClicked () {
    $('.navbar-v2').toggleClass('search-opened')
    $('.navbar-v2').toggleClass('menu-opened', false)
    $('#getkong-algolia-search-input').focus()
}

function toggleButtonClicked () {
    if (!$('.navbar-v2').hasClass('search-opened')) {
        $('.navbar-v2').toggleClass('menu-opened')
    } else {
        $('.navbar-v2').toggleClass('search-opened', false)
    }
}

function toggleSubmenuVisible (element) {
    $(element).toggleClass('submenu-title')
    $(element.parentElement).toggleClass('submenu-opened')
}

function getSearchPlaceholder () {
    var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
    if (w <= 800) {
    document.getElementById('getkong-algolia-search-input').placeholder = 'Search...';
    } else {
    document.getElementById('getkong-algolia-search-input').placeholder = 'Search the docs...';
    }
}

getSearchPlaceholder();
window.addEventListener('resize', getSearchPlaceholder);
