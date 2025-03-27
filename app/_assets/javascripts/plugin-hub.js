/* Hub page */

$(document).ready(function () {
  var queryParams = new URLSearchParams(window.location.search);

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

  function filterByCategories($categoryFilter) {
    var selectedCategories = getSelectedValuesForFilter($categoryFilter);
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
    var selectedSupport = getSelectedValuesForFilter($supportFilter);
    var selectedCompatibility = getSelectedValuesForFilter($compatibilityFilter);
    var searchQuery = $searchInput[0].value.toLowerCase();

    $(".plugin-card").each(function(_index, card) {
      var showCard = true;
      showCard = showCard && passesFilters(card, selectedSupport);
      showCard = showCard && passesFilters(card, selectedCompatibility);

      if (searchQuery !== '') {
        var meta = $(card).find('.plugin-card--meta__name')[0];

        var searchStrings = $(meta).data("search").split(", "); // Search aliases
        searchStrings.push(meta.innerText.toLowerCase()) // Card title

        var searchMatches = false;
        searchStrings.forEach(function(value){
          searchMatches = searchMatches || value.includes(searchQuery)
        });

        showCard = showCard && searchMatches;
      }
      $(card).toggle(showCard);
    });

    toggleCategoriesIfEmpty();
  }

  function toggleCategoriesIfEmpty() {
    $('.page-hub--category').each(function(_index, category) {
      if ($(category).find('.plugin-card:visible').length === 0) {
        $(category).toggle(false);
      }
    });
  }

  function toggleDropdownItem($filter, $dropdownItem) {
    var value = $dropdownItem.data("value");
    if (value === "all")  {
      $filter.find(".dropdown-item").removeClass("active");
      $dropdownItem.addClass("active");
    } else {
      $dropdownItem.toggleClass("active");
      $filter.find(".dropdown-item[data-value='all']").removeClass("active");
    }
    // if none selected -> select "all"
    if ($filter.find(".dropdown-item.active").length === 0) {
      $filter.find(".dropdown-item[data-value='all']").addClass("active");
    }
    // if every option selected -> select all
    if ($filter.find(".dropdown-item").length > 2) {
      if ($filter.find(".dropdown-item.active").length === $filter.find(".dropdown-item[data-value!='all']").length) {
        $filter.find(".dropdown-item[data-value!='all']").removeClass("active");
        $filter.find(".dropdown-item[data-value='all']").addClass("active");
      }
    }
    updateCounter($filter);
  }

  function updateCounter($filter) {
    var selected = getSelectedValuesForFilter($filter);
    var $counter = $filter.find(".selected-counter");

    if (areAllSelected(selected)) {
      $counter.css('visibility', 'hidden');
    } else {
      $counter.html(selected.length);
      $counter.css('visibility', 'visible');
    }
  }

  function handleDropdownChange($filter, $target) {
    toggleDropdownItem($filter, $target);

    $filter.trigger("page-hub:filter");
    $filter.find(".dropdown-menu").removeClass("open");
  }

  if ($(".page.page-hub").length !== 0) {
    var categoryIds = $.map($(".page-hub--category"), function(c) { return c.id; });
    var $categoryFilter = $(".page-hub--filters__filter-categories");
    var $supportFilter = $(".page-hub--filters__filter-support");
    var $compatibilityFilter = $(".page-hub--filters__filter-compatibility");
    var $searchInput = $("#filter-plugins");
    var typingTimer;
    var typeInterval = 500;

    function handleOldFilters() {
      var hash = window.location.hash;
      if (hash) {
        var value = hash.slice(1);
        if (value === "plus" || value === "ee-compat") {
          if (value === "ee-compat") {
            value = "enterprise";
          }
        }
      }
    }

    function populateFilter($filter, filterName) {
      var values = queryParams.get(filterName).split(",");
      values.forEach(function(val) {
        var $dropdownItem = $filter.find(`.dropdown-item[data-value='${val}']`);
        toggleDropdownItem($filter, $dropdownItem);
      });
    }

    function populateFiltersFromQueryString() {
      if (queryParams.size !== 0) {
        if (queryParams.has("category")) {
          populateFilter($categoryFilter, "category");
          filterByCategories($categoryFilter);
        }
        if (queryParams.has("support")) {
          populateFilter($supportFilter, "support");
        }
        if (queryParams.has("compatibility")) {
          populateFilter($compatibilityFilter, "compatibility");
        }
        if (queryParams.has("search")) {
          $searchInput.val(decodeURIComponent(queryParams.get("search")));
        }

        filterPluginCards();
      }
    };

    function updateQueryParamWithFilter(filterName, $filter) {
      var selectedValues = getSelectedValuesForFilter($filter);

      if (areAllSelected(selectedValues)) {
        queryParams.delete(filterName);
      } else {
        queryParams.set(filterName, selectedValues.join(","));
      }
    }

    function updateQueryParamWithInputValue() {
      var inputValue = $searchInput[0].value.toLowerCase();
      if (inputValue === "") {
        queryParams.delete("search");
      } else {
        queryParams.set("search", encodeURIComponent(inputValue));
      }
    }

    function updateQueryParams() {
      var $categoryFilter = $(".page-hub--filters__filter-categories");
      var $supportFilter = $(".page-hub--filters__filter-support");
      var $compatibilityFilter = $(".page-hub--filters__filter-compatibility");

      updateQueryParamWithFilter("category", $categoryFilter);
      updateQueryParamWithFilter("support", $supportFilter);
      updateQueryParamWithFilter("compatibility", $compatibilityFilter);
      updateQueryParamWithInputValue();

      history.replaceState(null, "", `?${queryParams.toString()}`);
    }

    $(".page-hub--filters").on("page-hub:filter", function(e) {
      filterByCategories($categoryFilter);
      filterPluginCards();
      updateQueryParams();
    });

    $(".page-hub--filters").on("click", ".clear-search", function(e) {
      $searchInput.val("");
      $searchInput.trigger("page-hub:filter");
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

    populateFiltersFromQueryString();
    handleOldFilters();
  }
});
