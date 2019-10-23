---
title: Adding New Dev Portal Registration Fields
toc: false
---


### Introduction

By default, when authentication is enabled for a Dev Portal the only required
fields are **full name**, **email**, and **password**. However, additional fields can be added
to this form.


### Adding Additional Registration Fields

1. In Kong Manager, navigate to the desired workspace's Dev Portal **Settings** page.

2. Click the **Developer Meta Fields** tab on the **Settings Page**

3. Click **+ Add Field** to add a new field object to the form.

4. Give the new field a label, field name, and select the type of input

5. Select the checkbox **Required** to require this field for registration

6. Click the **Save Changes** button a the bottom of the form.

![Developer Meta Fields](https://konghq.com/wp-content/uploads/2019/05/developer-meta-fields.png)

Once saved, the new field will automatically be added to the registration form.

> **WARNING** Adding new required fields to registration will block existing
> developers from logging in. They will need to be removed and re-registered.