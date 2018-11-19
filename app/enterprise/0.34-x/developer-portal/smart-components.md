---
title: Using Smart Components with the Dev Portal
---

## Working with Components in the Dev Portal

The Dev Portal makes accessible both Vue and React to be used within it's template files. The Default Dev Portal ships with a few examples of how you can use these 'smart components' in your portal.  Working with Vue/React within handlebars templates will feel familiar outside of a few caveats which will be covered below.

1. Filetype
  - All non-spec files must have a primary filetype of `.hbs` (handlebars).  As a result Vue components are written within `.hbs` files, it is suggested to indicate this by appending `-vue` to the filename: `sample.hbs` -> `sample-vue.hbs`

2. Instantiation
  - In order to render correctly you must instantiate components within a callback passed to `window.registerApp`. `Vue` and `React` libraries are accessible via the window as well.

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

3. Delimiters
- Handlebars & Vue share the use of `{{ }}` template delimiters, this will cause issues as the libraries will not know which fields should be used by who.  For this reason it necessary to indicate custom delimiters in your Vue template, as can be seen in the example component below:

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
    ```
  {% endraw %}

4. File Structure
  - Vue maintains its general structure when written within handlebars and consists of `template`, `component`, and `style` sections.

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

5. Importing
  - If you would like to import logic from another file (for example if two components use shared logic), you can do so via handlebars partials. In order to access the logic contained in the imported file, attach functions to the window.  Reference `partials/search/widget.hbs` or `partials/spec/dropdown.hbs` in the default dev portal which act as working examples of how this can be done.

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
