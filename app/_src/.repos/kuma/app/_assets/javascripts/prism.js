import Prism from 'prismjs'
import 'prismjs/plugins/line-numbers/prism-line-numbers.min.js'
import 'prismjs/components/prism-bash.min.js'
import 'prismjs/components/prism-yaml.min.js'
import 'prismjs/components/prism-json.min.js'

import 'prismjs/plugins/show-language/prism-show-language.min.js'
import 'prismjs/plugins/autoloader/prism-autoloader.min.js'
import 'prismjs/plugins/toolbar/prism-toolbar.min.js'
import 'prismjs/plugins/toolbar/prism-toolbar.min.css'
import "prismjs/plugins/copy-to-clipboard/prism-copy-to-clipboard.min.js";

import 'prismjs/themes/prism.min.css'
import "prismjs/themes/prism-tomorrow.min.css";
import 'prismjs/plugins/line-numbers/prism-line-numbers.min.css'

import '@/styles/prismjs/prism-vs.scss'

Prism.highlightAll();

document.addEventListener('DOMContentLoaded', (event) => {
  document.querySelectorAll('.copy-to-clipboard-button').forEach((elem) => {
    let icon = '<span><svg data-v-49140617="" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" class="hover"><path data-v-49140617="" fill="none" d="M0 0h24v24H0z"></path> <path data-v-49140617="" fill="#4e1999" d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm-1 4l6 6v10c0 1.1-.9 2-2 2H7.99C6.89 23 6 22.1 6 21l.01-14c0-1.1.89-2 1.99-2h7zm-1 7h5.5L14 6.5V12z"></path></svg></span>';
    elem.innerHTML = icon + '<span>Copied!</span>';
  });
});
