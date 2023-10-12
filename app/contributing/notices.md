---
title: Notes and other notices
content_type: reference
---

Notices are carefully selected, called-out text. 
They purposely break the flow of text to grab a reader's attention and highlight important information.

Notice types:
* **Note:** Information concerning behavior that would not be expected, but won't break anything if it's not followed.
* **Important:** Information that the reader really needs to pay attention to, otherwise things won't work.
* **Warning:** Information necessary to avoid breaking something or losing data.

You can set the notice label to anything you want. For example, you might
want an `important` note to start with **Protect your password!**:

{:.important}
> **Protect your password!**
> Store your password in a password manager. Never write passwords down on paper, or share them in plaintext.

## Best practices 

* When using notices, think about whether the thing you're trying to note is
_actually_ a note (or warning, or caution), or simply another piece of
information that fits the flow of the task or content on the page. 
* Avoid nesting too many elements inside notices.
* Keep notices short.
* Don't stack notices. You never want to place multiple notices one after the other.

## Notice types

Create a notice with Markdown blockquotes (`>`) and a class to display a specific style:

### Note

This is a generic note block that points out useful information that the
reader should pay attention to, but won't break anything if it's not followed.
If you don't use any class at all, the blockquote element defaults to this style.

```
{:.note}
> **Note**: Here's some info.
```

{:.note}
> **Note:** Here's some info.

### Important

Use the `important` block for something that the reader really
needs to pay attention to, otherwise the thing they're trying to do won't work.

```
{:.important}
> **Important:** Be cautious about this thing.
```

{:.important}
> **Important:** Be cautious about this thing.

### Warning 

Use the `warning` block for any breaking changes, or for anything
irreversible.

```
{:.warning}
> **Warning:** Everything will break forever if you do this.
```

{:.warning}
> **Warning:** Everything will break forever if you do this.


### No icon

If you have a situation where you need to use a specific notice type but
the icon doesn't belong, you can hide the icon by setting `no-icon` along
with any other notice class. For example, here's the result of using `{:.warning .no-icon}`:

```
{:.warning .no-icon}
> This is something that's vital in a special way and the icon doesn't apply.
```

{:.warning .no-icon}
> This is something that's vital in a special way and the icon doesn't apply.
