/* Hub page */

$(document).ready(function () {
  function getValuesForFilter(filter) {
    return $.map(filter.find(".dropdown-item"), function(t) {
      return $(t).data("value");
    });
  }

  function getSelectedValuesForFilter(filter) {
    return $.map(filter.find(".dropdown-item.active"), function(e) {
      return $(e).data("value");
    });
  }

  function areAllSelected(values) {
    return JSON.stringify(values) === JSON.stringify(["all"]);
  }

  function filterByCategories(selectedCategories) {
    var selectedIds = [];
    var unselectedIds = [];
    if (areAllSelected(selectedCategories)) {
      selectedIds = categoryIds;
    } else {
      selectedIds = selectedCategories;
      unselectedIds = $(categoryIds).not(selectedIds).get();
    }

    $(selectedIds).each(function(index, catId) {
      $(`#${catId}`).toggle(true);
    });
    $(unselectedIds).each(function(index, catId) {
      $(`#${catId}`).toggle(false);
    });
  }

  function passesFilters(card, filters) {
    var cardCssClasses = $(card)[0].classList;

    if (!areAllSelected(filters)) {
      return filters.some(function(elem) {
        return cardCssClasses.contains(elem);
      });
    } else {
      return true;
    }
  }

  function filterPluginCards() {
    var selectedTiers = getSelectedValuesForFilter($tierFilter);
    var selectedSupport = getSelectedValuesForFilter($supportFilter);
    var selectedCompatibility = getSelectedValuesForFilter($compatibilityFilter);
    var searchQuery = $searchInput[0].value.toLowerCase();

    $(".plugin-card").each(function(_index, card) {
      var showCard = true;
      showCard = showCard && passesFilters(card, selectedTiers);
      showCard = showCard && passesFilters(card, selectedSupport);
      showCard = showCard && passesFilters(card, selectedCompatibility);

      if (searchQuery !== '') {
        var cardTitle = $(card).find('.plugin-card--meta__name')[0].innerText.toLowerCase();
        showCard = showCard && cardTitle.includes(searchQuery);
      }
      $(card).toggle(showCard);
    });
  }

  function toggleCategoriesIfEmpty() {
    $('.page-hub--category').each(function(_index, category) {
      if ($(category).find('.plugin-card:visible').length === 0) {
        $(category).toggle(false);
      }
    });
  }

  function handleDropdownChange($filter, $target) {
    var value = $target.data("value");
    if (value === "all")  {
      $filter.find(".dropdown-item").removeClass("active");
      $target.addClass("active");
    } else {
      $target.toggleClass("active");
      $filter.find(".dropdown-item[data-value='all']").removeClass("active");
    }
    // if none selected -> select "all"
    if ($filter.find(".dropdown-item.active").length === 0) {
      $filter.find(".dropdown-item[data-value='all']").addClass("active");
    }
    $filter.trigger("page-hub:filter");
    $filter.find(".dropdown-menu").removeClass("open");
  }

  if ($(".page.page-hub").length !== 0) {
    var categoryIds = $.map($(".page-hub--category"), function(c) { return c.id; });
    var $categoryFilter = $(".page-hub--filters__filter-categories");
    var $tierFilter = $(".page-hub--filters__filter-tiers");
    var $supportFilter = $(".page-hub--filters__filter-support");
    var $compatibilityFilter = $(".page-hub--filters__filter-compatibility");
    var $searchInput = $("#filter-plugins");
    var typingTimer;
    var typeInterval = 500;

    $(".page-hub--filters").on("page-hub:filter", function(e) {
      var selectedCategories = getSelectedValuesForFilter($categoryFilter);;

      filterByCategories(selectedCategories);
      filterPluginCards();
      toggleCategoriesIfEmpty();
    });

    $tierFilter.on("click", ".dropdown-item", function(e) {
      handleDropdownChange($tierFilter, $(e.target));
    });

    $supportFilter.on("click", ".dropdown-item", function(e) {
      handleDropdownChange($supportFilter, $(e.target));
    });

    $compatibilityFilter.on("click", ".dropdown-item", function(e) {
      handleDropdownChange($compatibilityFilter, $(e.target));
    });

    $categoryFilter.on("click", ".dropdown-item", function(e) {
      handleDropdownChange($categoryFilter, $(e.target));
    });

    $searchInput.on("keyup", function() {
      clearTimeout(typingTimer);
      typingTimer = setTimeout(function() {
        $searchInput.trigger('page-hub:filter');
      }, typeInterval);
    });
  }
});
