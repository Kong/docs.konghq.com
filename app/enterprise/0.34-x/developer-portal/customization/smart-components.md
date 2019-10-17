---
title: Using Smart Components with the Dev Portal
---

## Working with Components in the Dev Portal

The Kong Dev Portal supports the use of Vue.js and React.js within the Dev 
Portal template files to customize the functionality and look of the Dev Portal.

Working with Vue within Handlebars templates will feel familiar outside of a few
 caveats which will be covered below.  In addition to this guide, the Default 
 Dev Portal ships with examples of how to use these 'smart components'.



### Filetype
All non-spec files must have a primary filetype of `.hbs` (Handlebars).  As a 
result Vue components are written within `.hbs` files, it is suggested to 
indicate this by appending `-vue` to the filename: `sample.hbs` -> 
`sample-vue.hbs`

### Instantiation
In order to render correctly components must be instantiated within a callback 
passed to `window.registerApp`. Vue and React libraries are accessible via the 
window.  After handlebars renders the initial template, the Dev Portal will 
iterate over and instantiate each component passed to it via `registerApp`.

{% raw %}
  ```handlebars
  {{!-- component --}}
  <script>
  // Place Vue/React code within a callback passed as an argument to `registerApp`.
  window.registerApp(function () {
    // Vue and React components are accessed via the `window` as well.
    new window.Vue({
      el: '#component',

      delimiters: ['${', '}'],

      data () {
        return {
          title: 'hello!'
        }
      }
    })
  })
  </script>
  ```
{% endraw %}

### Delimiters
Handlebars & Vue share the use of the same template delimiters, this will cause 
issues as the libraries will not know which fields should be used by who.  For 
this reason it is necessary to indicate custom delimiters in the Vue template:

{% raw %}
  ```handlebars
  {{!-- template --}}
  <div id="delimiters-example">
    <div class="handlebars-render">
      {{!-- Handlebars will render this content using its default '{{}}' delimiters --}}
      <p>{{ handlebarsContent }}<p>
    </div>

    <div class="vue-render">
      {{!-- Vue will render this content using the custom '${}' delimiters set below --}}
      <p>${ vueContent }<p>
    </div>
  </div>

  {{!-- component --}}
  <script>
  window.registerApp(function () {
    new window.Vue({
      el: '#delimiters-example',
      
      //Custom delimiters in Vue should be defined here
      delimiters: ['${', '}'],

      data () {
        return {
          vueContent: 'hello!'
        }
      }
    })
  })
   </script>
  ```
{% endraw %}

### File Structure
Vue maintains its general structure when written within handlebars and consists 
of `template`, `component`, and `style` sections.

{% raw %}
  ```handlebars
  {{!-- template --}}
  <div id="file-structure-example">
    <h1>${ title }<h1>
  </div>

  {{!-- component --}}
  <script>
  window.registerApp(function () {
    new window.Vue({
      el: '#file-structure-example',

      delimiters: ['${', '}'],

      data () {
        return {
          title: 'hello!'
        }
      }
    })
  })
  </script>

  {{!-- style --}}
  <style>
  h1 {
    font-size: 24px;
    color: red;
  }
  </style>
  ```
{% endraw %}

### Importing
Importing logic from one file to another can be done via a handlebars partial. 
In order to access the logic contained in the imported file, attach importable 
content to the window.  Reference `search/widget.hbs` or `spec/dropdown.hbs` 
partials in the default dev portal which act as working examples of how this can
 be done.


`import/helper-js.hbs`
{% raw %}
  ```handlebars
  <script>
  //create window.helpers object if needed
  if (!window.helpers) {
    window.helpers = {}
  }

  window.helpers.returnHelloWorld = () => {
    return 'Hello World!'
  }
  </script>
  ```
{% endraw %}


`import/example-vue.hbs`
{% raw %}
  ```handlebars
  {{!-- imports --}}
  {{> import/helper-js }}

  {{!-- template --}}
  <div id="import-example">
    <h1>${ returnHelloWorld }<h1>
  </div>

  {{!-- component --}}
  <script>
  window.registerApp(function () {
    new window.Vue({
      el: '#import-example',

      delimiters: ['${', '}'],

      data () {
        return {
          returnHelloWorld: console.log('error: returnHelloWorld helper failed to load')
        }
      },

        mounted () {
        if (window.helpers) {
          // assign helper if available, log error if not
          this.returnHelloWorld = window.helpers.returnHelloWorld || this.returnHelloWorld
        }
      }
    })
  })
  </script>
  ```
{% endraw %}
