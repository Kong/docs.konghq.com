const $$ = ($el, sel) => $el.querySelectorAll(sel)
const $ = ($el, sel) => $el.querySelector(sel)

const get = (key, d = null) => {
  try {
    const val = localStorage.getItem(key)
    return val !== null ? JSON.parse(val) : d
  } catch(e) {
    return d
  }
}

const set = (key, value) => {
  if(get(key) === value) {
    return
  }
  localStorage.setItem(key, JSON.stringify(value))
  window.dispatchEvent(new StorageEvent('storage', { key: key }))
}


const KEY = 'mesh-service-support';
class MeshServiceSwitcher {
  constructor(elem) {
    this.elem = elem;
    const $toggles = $$(this.elem, '.meshservice');

    // when any checkbox is clicked, sync the storage
    [...$toggles].forEach($item => $item.addEventListener('change', (e) => set(KEY, e.target.checked)));

    // listen for all storage events/syncs, i.e. changes
    window.addEventListener('storage', (e) => {
      if(e.key === KEY) {
        [...$toggles].forEach($item => {
          // the $bits we need
          const $checkbox = $($item, 'input[type="checkbox"]');
          const $legacy = $($item.parentNode, '.meshservice ~ .language-yaml:nth-child(2)');
          const $meshService = $($item.parentNode, '.meshservice ~ .language-yaml:nth-child(3)');

          // get the changed value and update the view
          const enabled = get(KEY, e.key);
          $checkbox.checked = enabled;

          (enabled ? $meshService : $legacy).classList.remove('hidden');
          (!enabled ? $meshService : $legacy).classList.add('hidden');
        })
      }
    })
    
    // fire a fake event to update the view
    window.dispatchEvent(new StorageEvent('storage', { key: KEY }));
  }
}

class TabsComponent {
  constructor(elem) {
    this.elem = elem;
    this.options = this.elem.dataset;

    this.addEventListeners();
  }

  addEventListeners() {
    this.elem.querySelectorAll('li.tabs-component-tab').forEach((item) => {
      item.addEventListener('click', this.selectTab.bind(this));
    });

    // Listen for the custom event to update tabs
    document.addEventListener('tabSelected', this.onTabSelected.bind(this));
  }

  selectTab(event) {
    event.stopPropagation();
    if (!this.options['useUrlFragment']) {
      event.preventDefault();
    }
    event.target.scrollIntoView({ behavior: "smooth", block: "start" });
    const selectedTab = event.currentTarget;
    this.setSelectedTab(selectedTab);
    this.dispatchTabSelectedEvent(event.target.dataset.slug);
  }

  hideTabs(selectedTab) {
    selectedTab
      .closest('.tabs-component')
      .querySelectorAll(':scope > .tabs-component-tabs > .tabs-component-tab')
      .forEach((item) => {
        item.classList.remove('is-active');
        item.querySelector('.tabs-component-tab-a').setAttribute('aria-selected', false);
      });

    selectedTab
      .closest('.tabs-component')
      .querySelectorAll(':scope > .tabs-component-panels > .tabs-component-panel')
      .forEach((item) => {
        item.classList.add('hidden');
        item.setAttribute('aria-hidden', true);
      });
  }

  dispatchTabSelectedEvent(tabSlug) {
    const event = new CustomEvent('tabSelected', { detail: { tabSlug } });
    document.dispatchEvent(event);
  }

  onTabSelected(event) {
    const { tabSlug } = event.detail;
    this.setSelectedTabBySlug(tabSlug);
  }

  setSelectedTab(selectedTab) {
    this.hideTabs(selectedTab);

    selectedTab.classList.add('is-active');
    selectedTab.querySelector('.tabs-component-tab-a').setAttribute('aria-selected', true);

    const tabLink = selectedTab.querySelector('.tabs-component-tab-a');
    const panelId = tabLink.getAttribute('aria-controls');
    const selectedPanel = this.elem.querySelector(`.tabs-component-panel[id="${panelId}"]`);

    selectedPanel.classList.remove('hidden');
    selectedPanel.setAttribute('aria-hidden', false);
  }

  setSelectedTabBySlug(slug) {
    const tab = Array.from(
      this.elem.querySelectorAll('li.tabs-component-tab')
    ).find(tab => tab.querySelector('.tabs-component-tab-a').dataset.slug === slug);

    if (tab) {
      this.setSelectedTab(tab);
    }
  }
}

export default class Tabs {
  constructor() {
    document.querySelectorAll('.tabs-component').forEach((elem) => {
      new TabsComponent(elem);
      if ($(elem, '.meshservice')) {
        new MeshServiceSwitcher(elem)
      }

    });
  }
}
