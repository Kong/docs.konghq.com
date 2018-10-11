---
title: Kong Developer Portal Best Practices
book: portal
chapter: 12
---

# Kong Developer Portal Best Practices

The Kong Developer Portal is a powerful tool. It's part static website and part interactive API. With a tool of this magnitude, there are countless ways to configure and host that will vary greatly depending on your needs. The following article is a group of recommendations we have found which lead to  easy administrative and top performance. This list is not exhaustive, so if you have a trick you like to use and want to share it with others, please feel free to make a PR on the page, or send us an email at <support@konghq.com> and we can add it for you.

___

- [Basic System Requirements and Initial Configuration](#basic-system-requirements-and-initial-configuration)
- [Customizing The Portal Design with CSS](#customizing-the-portal-design-with-css)
- [Customizing Front End Behavior with JavaScript](#customizing-front-end-behavior-with-javascript)
- [Using Source Control with Git](#using-source-control-with-git)
- [Effective Partial Usage](#effective-partial-usage)
- [Practices to Avoid](#practices-to-avoid)
___

## Basic System Requirements and Initial Configuration

When deciding what type of system to host Kong on, you should take into consideration into the amount of traffic you expect the portal to see. If you are using your portal only for internal APIs shared between 2 teams, you'll need a much smaller instance than someone with a public facing, heavily trafficked API. By default, I suggest starting with a more powerful machine than you need and scaling back. If you have a bit more power than you need, none of your end users will notice a difference. However, if you start too small, it could potentially lead to a slower performance of the portal. This section is going to assume your portal gets about 1000 concurrent visitors on average.

If you are using AWS for you hosting, a [t2.large](https://aws.amazon.com/ec2/instance-types/t2/) is a starting place. This is a solid base and should be able to handle expectations without any issue. If you use Google Cloud (GCE), try starting with a [n1-standard-2](https://cloud.google.com/compute/pricing#standard_machine_types) and if you are using the Azure cloud, start with a [Standard_D2_v3](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-general#dv3-series-sup1sup).

If you look at those recommendations, you'll see they all have similar starts:
  - At least 2 CPUs
  - Around 8 GiB System memory

If possible, it's best practice to have this Kong instance be used to only serve the dev portal, and not do any Kong administrative work. To do this, in your kong.conf file, set the following values
```
admin_listen=off
portal=on
```
We will also want to ensure all other instances of Kong have the portal boolean set to off. This ensures your portal is only being served by a single Kong instance.

## Customizing The Portal Design with CSS

The Developer Portal has two files that contain CSS and are used to control the design. The main CSS file is `unauthenticated/theme-css` which contains the bulk of the CSS styles for the default layout. The second file is `unauthenticated/custom-css` where owners add and edit their own custom css. Both of these files can be accessed by non authenticated pages. You can access the custom-css file by using the Admin API
```
curl http://localhost:8001/files/unauthenticated/custom-css
```

This will return the a JSON object that represents the custom-css file. It contains metadata about the file, and the `contents` field contains the actual CSS data. You should save the `contents` to a file, and edit it to your liking. Edit the CSS to customize the look of your portal.

When you have customized the CSS, you will then upload it to the Files API. This will make the Dev Portal use the CSS for when it serves content, and show your custom design.
```
curl -X PATCH \
   -- url http://localhost:8001/files/unauthenticated/custom-css \
   -F contents=@custom.css
```

In this example the name of the file on disk is `custom.css`. You are free to name this whatever you like, so long as you send your changes to the `unauthenticated/custom-css` file. This specific place is where the Kong Dev Portal will look for custom CSS.


## Customizing Front End Behavior with JavaScript

Including custom javascript is similar to customizing CSS.

In order to use custom javascript we need to download the `custom-js` file, make our custom changes, and then upload those changes to the `custom-js` file.

Use this command to get the JSON object that represents the `custom-js` file
```
curl http://localhost:8001/files/custom-js
```

Once you have this, save the value of the `contents` field to a file. This is the file we will use to add custom JavaScript. Once the file has been edited it will need to be uploaded to the `custom-js` file. Use this command to upload your changes. This command assumes the name of the file is `custom-js`<br />
```
curl -X PATCH \
   -- url http://localhost:8001/files/custom-js \
   -F contents=@custom-js
```

Once uploaded your changes will be served on each page request.


## Using Source Control with Git

Kong gives you the ability to edit files directly in the Kong GUI. While this may be easy, it will not maintain a history of the changes you've made. Each file will only exist in it's most current form. We have found the best approach is to have a dedicated repo for you portal.

In a new repository, recreate all of the files in your portal there. The general layout of files (pages, partials and specs). The default structure is:
```
├── assets
│   ├── fonts
│   │   ├── MaterialIcons-Regular.ttf
│   │   ├── Roboto-Bold.ttf
│   │   ├── Roboto-BoldItalic.ttf
│   │   ├── Roboto-Italic.ttf
│   │   ├── Roboto-Medium.ttf
│   │   ├── Roboto-MediumItalic.ttf
│   │   └── Roboto-Regular.ttf
│   ├── images
│   │   └── example-spec-list.svg
│   └── style
│       ├── app.scss
│       ├── base
│       │   ├── _alerts.scss
│       │   ├── _base.scss
│       │   ├── _fonts.scss
│       │   ├── _forms.scss
│       │   └── _variables.scss
│       ├── layout
│       │   ├── _footer.scss
│       │   ├── _header.scss
│       │   ├── _headerDropdown.scss
│       │   └── _sidebar.scss
│       ├── pages
│       │   ├── _404.scss
│       │   ├── _guides.scss
│       │   ├── _index.scss
│       │   └── login.scss
│       ├── theme-css.hbs
│       └── util
│           ├── _fixes.scss
│           └── _spec-ui.scss
├── index.html
├── js
│   ├── Api.js
│   ├── Auth.js
│   ├── HbsManager.js
│   ├── config.js
│   ├── dashboard
│   │   ├── App.vue
│   │   ├── components
│   │   │   ├── ChartControls.vue
│   │   │   ├── ChartTooltip.vue
│   │   │   ├── CredentialForm.vue
│   │   │   ├── CredentialFormModal.vue
│   │   │   ├── CredentialTable.vue
│   │   │   ├── DevRequestsChart.vue
│   │   │   └── LineChart.vue
│   │   ├── mixins
│   │   │   ├── polling.js
│   │   │   └── toaster.js
│   │   ├── pages
│   │   │   └── dashboard.vue
│   │   └── schemas
│   │       ├── ACL.js
│   │       ├── BasicAuth.js
│   │       ├── HMAC.js
│   │       ├── JWT.js
│   │       ├── KeyAuth.js
│   │       ├── OAuth2.js
│   │       └── plugins.js
│   ├── dashboard.js
│   ├── site.js
│   └── utils
│       ├── common.js
│       ├── error.js
│       ├── route.js
│       ├── spec.js
│       └── vitals.js
└── templates
    ├── pages
    │   ├── 404.hbs
    │   ├── about.hbs
    │   ├── dashboard.hbs
    │   ├── documentation
    │   │   ├── api1.hbs
    │   │   ├── api2.hbs
    │   │   └── loader.hbs
    │   ├── guides
    │   │   ├── 5-minute-quickstart.hbs
    │   │   ├── index.hbs
    │   │   ├── kong-architecture-overview.hbs
    │   │   ├── kong-ee-introduction.hbs
    │   │   ├── kong-vitals.hbs
    │   │   └── uploading-spec.hbs
    │   ├── index.hbs
    │   ├── unauthenticated
    │   │   ├── 404.hbs
    │   │   ├── index.hbs
    │   │   ├── login.hbs
    │   │   ├── register.hbs
    │   │   └── unauthorized.hbs
    │   └── user.hbs
    ├── partials
    │   ├── custom-js.hbs
    │   ├── footer.hbs
    │   ├── header.hbs
    │   ├── kong-docs-sidebar.hbs
    │   ├── layout.hbs
    │   ├── sidebar-spec.hbs
    │   ├── sidebar.hbs
    │   ├── spec-dropdown.hbs
    │   ├── spec-renderer.hbs
    │   └── unauthenticated
    │       ├── auth-js.hbs
    │       ├── code-snippet-languages.hbs
    │       ├── custom-css.hbs
    │       ├── footer.hbs
    │       ├── header.hbs
    │       ├── layout.hbs
    │       ├── login-actions.hbs
    │       └── title.hbs
    └── specs
        ├── admin.json
        ├── files.yaml
        └── vitals.yaml
```

When the file structure is setup, you can make use of [GitHub Webhooks](https://developer.github.com/webhooks/creating/) and every time you merge a change into the Master branch, it triggers a push of files to the portal. This allows your developers to work in an environment they are familiar with, and maintain a history of changes to your portal. It also means you can easily roll back to a previous version.

## Effective Partial Usage

Partials in the portal allow you to create reusable elements of a page. A page will traditionally be made up of a group of partials. For example, if you wanted to create a page announcing a new product, you would probably want to include things such as the header, footer, sidebar etc. Each of those elements are saved as partials. For more information about partials, please refer to [our documentation](https://docs.konghq.com/enterprise/0.33-x/developer-portal/file-management/#partials).

Partials allow you to control what is on every page. In order for your portal to load quickly, it is vital to keep these files as small as possible. The general rule is partials should be around 500 kB. They should never be larger than 1 MB.

In order to achieve this, make sure to not do more than what is necessary for every partial. If something is not needed on every page, avoid placing it in a global file and instead, pull it into it's own partial.


## Practices to Avoid

You should never, under any circumstances store images or other media files in your Kong database. We suggest using a Content Delivery Network (CDN) or keeping them in an S3 bucket.
