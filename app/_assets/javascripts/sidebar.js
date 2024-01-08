'use strict';

class Sidebar {
  constructor(domNode, page) {
    this.currentUrl = page.dataset.url;
    this.domNode = domNode;
    this.treeItems = this.domNode.querySelectorAll("[role='treeitem']");
    this.productDropdown = this.domNode.querySelector("#module-list");
    this.versionDropdown = this.domNode.querySelector("#version-list");

    this.initMenu();
  }

  initMenu() {
    this.treeItems.forEach((item, index) => {
      item.addEventListener("keydown", this.onKeyDown.bind(this));
      item.addEventListener("click", this.onClick.bind(this));
      item.addEventListener("focus", this.closeProductAndVersionDropdowns.bind(this));
      if (index === 0) {
        item.tabIndex = 0;
      } else {
        item.tabIndex = -1;
      }
    });
    this.updateCurrentPage();
  }

  onKeyDown(event) {
    let target = event.currentTarget,
      flag = false,
      key = event.key;

    switch (key) {
      case 'ArrowUp':
        this.setFocusToPreviousTreeitem(target);
        flag = true;
        break;
      case 'ArrowDown':
        this.setFocusToNextTreeitem(target);
        flag = true;
        break;
      case 'ArrowRight':
        if (this.isExpandable(target)) {
          if (this.isExpanded(target)) {
            this.setFocusToNextTreeitem(target);
          } else {
            this.expandTreeitem(target);
            this.setTabIndex(target);
          }
        }
        flag = true;
        break;
      case 'ArrowLeft':
        if (this.isExpandable(target) && this.isExpanded(target)) {
          this.collapseTreeItems(target);
          this.setTabIndex(target);
          flag = true;
        } else {
          if (this.isInSubtree(target)) {
            this.setFocusToParentTreeitem(target);
            flag = true;
          }
        }
        break;
      case ' ':
      case 'Enter':
        this.onEnter(event);
        break;
    }
    if (flag) {
      event.stopPropagation();
      event.preventDefault();
    }
  }

  onEnter(event) {
    let target = event.currentTarget;
    if (target.getAttribute('aria-owns')) {
      this.onClick(event);
    } else {
      target.querySelector('.sidebar-link').click();
    }
  }

  onClick(event) {
    let target = event.currentTarget;
    this.closeProductAndVersionDropdowns();

    if (target.getAttribute('aria-owns')) {
      if (this.isExpanded(target)) {
        this.collapseTreeItems(target);
      } else {
        this.expandTreeitem(target);
      }
      event.preventDefault();
      event.stopPropagation();
    }
  }

  // close product or version dropdown menu when tabbing on the first navigation menu item
  closeProductAndVersionDropdowns() {
    if (this.productDropdown && this.productDropdown.classList.contains("open")) {
      this.productDropdown.classList.remove("open");
    }
    if (this.versionDropdown && this.versionDropdown.classList.contains("open")) {
      this.versionDropdown.classList.remove("open");
    }
  }

  setFocusToPreviousTreeitem(treeitem) {
    var visibleTreeItems = this.getVisibleTreeitems();
    var prevItem = false;

    for (var i = 0; i < visibleTreeItems.length; i++) {
      var ti = visibleTreeItems[i];
      if (ti === treeitem) {
        break;
      }
      prevItem = ti;
    }

    if (prevItem) {
      this.setFocusToTreeitem(prevItem);
    }
  }

  setFocusToNextTreeitem(treeItem) {
    var visibleTreeItems = this.getVisibleTreeitems();
    var nextItem = false;

    for (var i = visibleTreeItems.length - 1; i >= 0; i--) {
      var ti = visibleTreeItems[i];
      if (ti === treeItem) {
        break;
      }
      nextItem = ti;
    }
    if (nextItem) {
      this.setFocusToTreeitem(nextItem);
    }
  }

  getVisibleTreeitems() {
    let items = [];

    this.treeItems.forEach((item) => {
      if (this.isVisible(item)) {
        items.push(item);
      }
    })
    return items;
  }

  isVisible(treeItem) {
    if (this.isInSubtree(treeItem)) {
      treeItem = this.getParentTreeitem(treeItem);
      if (!treeItem || treeItem.getAttribute('aria-expanded') === 'false') {
        return false;
      }
    }
    return true;
  }

  isInSubtree(treeItem) {
    return this.parents(treeItem, "[role='group']").length > 0;
  }

  getParentTreeitem(treeItem) {
    var node = treeItem.parentNode;

    if (node) {
      node = node.parentNode;
      if (node) {
        node = node.previousElementSibling;
        if (node && node.getAttribute('role') === 'treeitem') {
          return node;
        }
      }
    }
    return false;
  }

  setFocusToTreeitem(treeItem) {
    treeItem.focus();
  }

  isExpandable(treeItem) {
    return treeItem.hasAttribute('aria-expanded');
  }

  isExpanded(treeItem) {
    return treeItem.getAttribute('aria-expanded') === 'true';
  }

  expandTreeitem(treeItem) {
    // close other top-level menus
    let parentMenu = treeItem.parentNode.parentNode;
    if (parentMenu.role === "tree") {
      let activeMenu = this.domNode.querySelector(':scope .sidebar-item.active [role=treeitem]');
      if (activeMenu) {
        this.collapseTreeItems(activeMenu);
      }
    } else if (parentMenu.role === "group") {
      // close other sibling menus
      Array.from(parentMenu.querySelectorAll('.sidebar-item'))
        .filter((child) => child !== treeItem.parentNode)
        .forEach((sidebarItem) => {
          this.collapseTreeItems(sidebarItem.querySelector('[role=treeitem]'));
        });
    }

    if (treeItem.getAttribute('aria-owns')) {
      var groupNode = document.getElementById(
        treeItem.getAttribute('aria-owns')
      );
      if (groupNode) {
        treeItem.setAttribute('aria-expanded', 'true');
        treeItem.parentElement.classList.add("active");
      }
    }
  }

  collapseTreeItems(treeItem) {
    if (treeItem.getAttribute('aria-owns')) {
      var groupNode = document.getElementById(
        treeItem.getAttribute('aria-owns')
      );
      if (groupNode) {
        this.collapseTreeItem(treeItem);
        groupNode.querySelectorAll('[role=treeitem]').forEach((item) => {
          this.collapseTreeItem(item);
        })
      }
    }
  }

  collapseTreeItem(treeItem) {
    treeItem.setAttribute('aria-expanded', 'false');
    treeItem.parentElement.classList.remove("active");
  }

  setFocusToParentTreeitem(treeItem) {
    if (this.isInSubtree(treeItem)) {
      var ti = this.getParentTreeitem(treeItem);
      this.setFocusToTreeitem(ti);
    }
  }

  updateCurrentPage() {
    const urlNoSlash = this.currentUrl.slice(0, -1);

    this.treeItems.forEach((item) => {
      let link = item.querySelector('.sidebar-link:first-child');

      if (link) {
        let itemUrl = link.getAttribute('href');
        if (itemUrl === this.currentUrl || itemUrl === urlNoSlash) {
          item.setAttribute("aria-current", "page");
          this.showTreeItem(item, true);
          this.setTabIndex(item);
        } else {
          item.removeAttribute("aria-current");
        }
      } else {
        item.removeAttribute("aria-current");
      }
    });
  }

  setTabIndex(treeItem) {
    this.treeItems.forEach((item) => (item.tabIndex = -1));
    treeItem.tabIndex = 0;
  }

  showTreeItem(treeItem, current) {
    const activeNav = treeItem.parentElement;

    activeNav.classList.add("active");
    if (current) {
      activeNav.classList.add("current");
    }
    this.parents(activeNav, ".sidebar-item").forEach((parent) => {
      parent.classList.add("active");
      if (current) {
        parent.classList.add("current");
      }
    })

    var parentNode = this.getParentTreeitem(treeItem);
    while (parentNode) {
      parentNode.setAttribute('aria-expanded', 'true');
      parentNode = this.getParentTreeitem(parentNode);
    }
  }

  parents(el, selector) {
    const parents = [];
    while ((el = el.parentNode) && el !== document) {
      if (!selector || el.matches(selector)) parents.push(el);
    }
    return parents;
  }
}

window.addEventListener("load", (event) => {
  const currentPage = document.querySelector(".page.v2");
  const sidebar = document.querySelector(".docs-sidebar");

  if (currentPage) {
    new Sidebar(sidebar, currentPage);
  }
});
