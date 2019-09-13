# Documentation Style Guide

### active voice
Use the active voice. See [personal pronouns](#personal-pronouns) for guidance 
on when it is appropriate to use "you" and "your".

* Bad: The files should be added to the directory by the owner.
* **_Good_: The owner should add the files to the directory.**
* Bad: To access a network's LDAP services, your computer must first be authenticated.
* **_Good_: To access a network's LDAP services, a server that supports the protocol must first authenticate your computer.**

### Admin, admin
Use proper case for the Kong entity, lowercase for the RBAC Role.

* Invite the **_Admin_** using the **Organization** tab
* The default **Roles** are **super-admin**, **_admin_**, and **read-only**

### Admin API 
Use proper case.

### Admin GUI
Use *Kong Manager* instead.

### American English
Use American English throughout Kong documentation.

### ampersands
Always use "and" in content, only use "&" in titles with two items that have 
always had it or in product names.

### API
All upper case; if referring to an entity, use **Services** and **Routes** 
instead.

### Basic Auth, Basic Authentication
Use proper case; abbreviate if the context permits. Only use lowercase (with a 
hyphen) in code or configuration samples.

* Bad: Options include LDAP Auth and basic auth.
* **_Good_: Options include LDAP Auth and Basic Auth.**
* *Bad*: Ensure that `admin_gui_auth` is set to basic auth.
* **_Good_: Ensure that `admin_gui_auth` is set to `basic-auth`.**
* **_Good_: Ensure that `admin_gui_auth = basic-auth`.**

### bold text
Use bold text for: 
* Visible GUI text, e.g., click the **Organization** tab.
* Usernames or Workspace names, e.g., **Gruce** or **Payments**
* Term lists, e.g.,
   * **bucanneers**: 17th-century French hunters who survived on the island of 
      Hispaniola by hunting wild cattle and swine and smoking the meat in a 
      wooden frame called a *boucane*, whence *boucaniers*. Many became pirates 
      after being driven off the island by the Spanish.
   * **pirates**: people who commit unsanctioned theft by use of a vessel. 
   * **privateers**: civilian sailors licensed to attack an enemy of their 
      country at war and keep the plunder on condition of paying their
      government a certain percentage. Many would turn to piracy when the war 
      officially ended.
* Emphasis when changing context for a command, like switching to a new 
  workspace or user, e.g.,
    > Log in as a **super admin** and move from the **default** 
    > workspace to **Payments**. Then check the **Admins** page to see if 
    > **Gruce** has accepted the invitation.

Do not use bold text for [headings](#heading) or anything that should be 
formatted with [in-line code](#in-line-code).

### click
Do not use "click on"; specify _what_ is being clicked.

* *Bad*: Click on **Admins**. 
* *Bad*: Look for one that says "Admins" and click.
* **_Good_: Click the Admins button.**

### code block
Use a code block to indicate multiple lines of code or an example command. For 
one line, see [in-line code](#in-line-code).

To write a code block, add 3 backticks (` ``` `) to the top and bottom of the 
block.

```
$ kong migrations bootstrap
```

If a specific language is used, specify it. For example, this block:

```
    ```javascript
    let password = 'hunter2'              // use 'quotes' for strings
    alert(`Your password is ${password}`) // use `ticks` for template literals
    ```
```

produces the contents with JavaScript's syntax highlighting:

```javascript
let password = 'hunter2'              // use 'quotes' for strings
alert(`Your password is ${password}`) // use `ticks` for template literals
``` 

### cURL
Do not write as "CURL" or "curl".

### e.g.
Indicates an inexhaustive list of examples, so "etc." is redundant. Use "i.e." 
if offering a clarification, rather than an example. Following the 
_Chicago Manual_, follow "e.g." with a comma before the example.

* *Bad*: Users may select a role, e.g. admin, read-only, etc.
* **_Good_: Users may select a role, e.g., admin, read-only.**
* *Bad*: The Role with the most RBAC permissions, e.g. the **super admin**.
* **_Good_: The Role with the most RBAC permissions, i.e., the super admin.**


### ellipses (...)
Indicates an incomplete thought or omission, not a pause thought; see 
[em-dash](#em-dash).

* *Bad*: Click "Garth-Stuff"... or more interestingly, the user named "KongOps".
* **_Good_: The error message will start, "Unable to complete request..."**

### em-dash (—)
Indicates a pause or emphatic break in a sentence; it is not a hyphen and has 
no surrounding space.

* *Bad*: The **admin Role** allows a user access to all endpoints... except for 
    RBAC **Permissions**.
* *Bad*: The **admin Role** allows a user access to all endpoints - except for 
    RBAC **Permissions**.
* **_Good_: The *admin Role* allows a user access to all endpoints—except for 
    RBAC *Permissions*.**

### explanatory guides
For explanatory sections, specify the value of the content, then provide 
clarification and examples. Avoid starting sections with casual or redundant 
information, e.g., "In this section, you'll learn how to do X." For example, 
in a section titled "Negotiation with Pirates":

* *Bad*: In this section, you will learn the reason for negotiating with 
    pirates. Pirates may seem scary, but they can be reasoned with. Just match 
    their body language and offer them some rum. From there, negotiation is 
    self-explanatory. Now you know how to negotiate with pirates.
* **_Good_: Although pirates do not abide by the law, it is possible to come to 
    a reasonable compromise with them. Their goal is financial gain, not a 
    fight, and many of them were once merchant sailors. If it is not possible 
    to deter them, it is best to maintain a friendly disposition. For the 
    safety of your crew, keep their motivations in mind at all times during 
    negotiation.**

### heading
For section headings, use `##`. For subsections, use `###`. Do not use `#` for 
a title, as it will nest the table of contents.

```
## Section 1

### Subsection 1.a

## Section 2

### Subsection 2.a

### Subsection 2.b
```

### how-to guides
Any section of documentation that is a guide involving multiple steps should 
have the following:

1. A title starting with "How to"
    * *Bad*: Creating New Admins in a Workspace
    * **_Good_: How to Create New Admins in a Workspace**
2. Numbered steps, 2 to 5 in length; anything with more than 5 steps 
    can be broken down into separate guides
3. Oriented towards a goal, not teaching; each step should be minimal and 
    straightforward
    * detailed explanation may go in a separate section below the how-to guide, 
        but should not interrupt it
    * *important* tags that prevent an undesired outcome may go at the bottom 
        of a step, but should not be overused
4. Each step in a how-to guide should be identical to its TL;DR version—if any 
    content is inessential, it can go into a blog post or a more appropriate 
    section

### HTTPie
Do not write "httpie" or "HTTPIE".

### i.e.
See e.g.; should only be used to specify a case, not offer possible examples.

### images
Included images should be 1200px wide. Introduce image concept *before* 
showing the image, not after.
See: [screenshots](#screenshots) and [videos](#vidoes)

### in-line code
Use in-line code formatting for:
* Command names, e.g., `kong start`
* Package names, e.g., `luarocks`
* Optional commands
* Variable names, e.g. `KONG_PASSWORD`
* Configuration properties and values, e.g., 
    * `admin_gui_auth`
    * `ldap-auth-advanced`
    * `admin_gui_auth = ldap-auth-advanced`
* File names and paths, like `~/.ssh/authorized_keys`
* Example URLs that are not active links, like `http://example.com`
* Ports, like `:3000`
* Key presses, which should be in ALL CAPS and use a plus symbol, `+`, if keys 
    need to be pressed simultaneously, such as `ENTER` or `CTRL+C`

For multiple lines of code or an example command, use a 
[code block](#code-block).

Do not use in-line formatting for anything that should be in 
[bold text](#bold-text).

### Kong
Use proper case.

### Kong Admin
Use **Admin** or **admin** (see [Admin, admin](#admin-admin)) instead.

### Kong Community Edition, Kong CE
Use *Kong* instead—except in pre-1.0 versions, e.g. "Kong CE 0.12".

### Kong Dev Portal
Use *Dev Portal* instead, not "Developer Portal".

### Kong Enterprise
Use proper case.

### Kong Enterprise Edition, Kong EE
Use *Kong Enterprise* instead—except in pre-34 versions, e.g. "Kong EE 0.32".

### Kong Manager
Use proper case.

### login, log in
Joined as a noun/modifier, separated as a phrasal verb; added prepositions are 
also separated.

* To see the dashboard, *log in* as an **admin**. 
* *Log in to* the app.
* Reset your password at the *login* page.

### numbering
Write all numbers as digits (including 1–9). Ranges should use an en-dash (–)
instead of "to" or "through".

* *Bad*: If a user has more than five bins, provide nine to 23 blocks.
* **_Good_: If a user has more than 5 bins, provide 9–23 blocks.** 
* *Bad*: This guide assumes steps one through three from the previous guide.
* **_Good_: This guides assumes steps 1–3 from the previous guide.**

### passive voice
See [active voice](#active-voice).

### personal pronouns 
Avoid "you" and "we" in favor of the specific role performing the task or the 
imperative mood, but do not use the passive voice if "you" would be simpler.

* *Bad*: We will start by creating credentials for you.
* **_Good_: To start, create credentials for the super admin.**
* *Bad*: Log in with the password that was set during migrations.
* **_Good_: Log in with the password you set during migrations.**

### Plugin
Use proper case.

### Role
Use proper case.

### Role-Based Access Control, RBAC
Use proper case, introduce full phrase only once per section, use abbreviation 
after.

### Routes
Use proper case.

### screenshots
Screenshots should be 1200px wide, do not include browser tool bars, 
title bars, url bars etc.

### serial comma 
For safety, clarity, and sanity.

### setup, set up
Joined as a noun/modifier, separated as a phrasal verb.

* A protocol is required to *set up* a service.
* To learn more, visit the account *setup* guide.  

### Services
Use proper case.

### super admin
Use lowercase, hyphen as a compound modifier. Note that an 
[Admin](#admin-admin) is a Kong entity, whereas **admin** and **super admin** 
refer to particular **Roles** assigned to an **Admin**, or users with those 
particular **Roles**.

* Invite a **_super admin_**.
* An **Admin** account may invite others if it has **_super-admin_** 
    **Permissions**.

### text in buttons, links
Maintain the case, format with [bold text](#bold-text).

* Click **Admins** in the sidebar.

* Use the **Add Role** button.

### titles
Prepositions and articles are lower case, everything else is proper case.

* Create RBAC **Roles** for an **Admin** in the **New** **Workspace**.

### utilize
Has a specific meaning, "to use what is available"; it should not be used a 
fancy synonym for "use".

* *Bad*: The Admin may *utilize* the feature to observe traffic.
* **_Good_: The Admin may *use* the feature to observe traffic.**

### videos
Videos should be less than 30 seconds in length, contain no voice-over
narration, and must be approved by a Kong member.

Include videos *after* the steps covered in the video have been introduced.

### Vitals
Use proper case.

### Workspace, Workspaces
Use proper case.
