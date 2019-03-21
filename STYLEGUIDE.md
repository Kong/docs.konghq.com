# Documentation Style Guide

### Admin
proper case

### Admin API 
proper case

### Admin GUI
use *Kong Manage*r instead

### American English
use American English throughout Kong documentation

### ampersands
always use “and” in content, only use “&” in titles with two items that have always had it or in product names

### API
all upper case; if referring to an entity, use Services and Routes instead

### Basic Auth, Basic Authentication
proper case, abbreviate if the context permits. Only use lowercase with a hyphen in code/config samples

* Bad: Options include LDAP Auth and basic auth.
* **_Good_: Options include LDAP Auth and Basic Auth.**
* *Bad*: Ensure that admin_gui_auth is set to basic auth.
* **_Good_: Ensure that admin_gui_auth is set to basic-auth.**
* **_Good_: Ensure that admin_gui_auth = basic-auth.**


### click
Do not use “click on”; specify what is being clicked

* *Bad*: Click on “Admins”
* *Bad*: Look for one that says “Admins” and click
* **_Good_: Click the “Admins” button**

### cURL
Do not useCURL or curl

### e.g.
Indicates an inexhaustive list of examples, thus should not conclude with “etc.”; if offering a clarification, rather than an example, use “i.e.”. Following the Chicago Manual, follow each with a comma.

* *Bad*: Users may select a role, e.g. admin, read-only, etc.
* **_Good_: Users may select a role, e.g., admin, read-only.**
* *Bad*: The Role with the most RBAC permissions, e.g. the Super Admin.
* **_Good_: The Role with the most RBAC permissions, i.e., the Super Admin.**


### ellipses (...)
Indicates an incomplete thought, not a pause in a sentence; see em-dash

### em-dash (—)
Indicates a pause or emphatic break in a sentence; it's not a hyphen and has no surrounding space

* *Bad*: The admin role allows a user access to all endpoints... except for RBAC permissions.
* *Bad*: The admin role allows a user access to all endpoints - except for RBAC permissions.
* **_Good_: The admin role allows a user access to all endpoints—except for RBAC permissions.**

### explanatory guides
For explanatory sections, specify the value of the content, then provide clarification and examples. Avoid starting sections with casual or redundant information, e.g., “In this section, you'll learn how to do X.” For example, in a section titled “Negotiation with Pirates”:

* *Bad*: In this section, you will learn the reason for negotiating with pirates. Pirates may seem scary, but they can be reasoned with. Just match their body language and offer them some rum. From there, negotiation is self-explanatory. Now you know how to negotiate with pirates.
* **_Good_: Although pirates do not abide by the law, it is possible to come to a reasonable compromise with them. Their goal is financial gain, not a fight, and many of them were once merchant sailors. If it is not possible to deter them, it is best to maintain a friendly disposition. For the safety of your crew, keep their motivations in mind at all times during negotiation.**

### How-To Guides
Any section of documentation that is a guide involving multiple steps should have the following:

1. A title starting with “How to”
    * *Bad*: Creating New Admins in a Workspace
    * **_Good_: How to Create New Admins in a Workspace**
2. Numbered steps ranging from two to five; anything with more than five steps can be broken down into separate guides
3. Oriented towards a goal, not teaching; each step should be minimal and straightforward
    * detailed explanation may go in a separate section below the how-to guide, but should not interrupt it
    * *important* tags that prevent an undesired outcome may go at the bottom of a step, but should not be overused
4. Each step in a how-to guide should be identical to its TL;DR version--if any content is inessential, it can go into a blog post or a more appropriate section

### HTTPie
Do not use httpie

### i.e.
See e.g.; should only be used to specificy a case, not offer possible examples

### Kong
Use proper case

### Kong Admin
Use Admin instead

### Kong Community Edition, Kong CE
Use Kong instead

### Kong Dev Portal
Use Dev Portal in docs, not “Developer Portal’

### Kong Enterprise
Use proper case

### Kong Enterprise Edition, Kong EE
Use Kong Enterprise instead—except in pre-34 versions, e.g. “Kong EE 0.32”

### Kong Manager
Use proper case

### login, log in
Joined as a noun/modifier, separated as a phrasal verb; added prepositions are also separated

* To see the dashboard, *log in* as an admin. 
* *Log in to* the app.
* Reset your password at the *login* page.

### numbering
Spell out numbers less than 10

* *Bad*: There are 2 properties to set in the config.
* **_Good_: There are two properties to set in the config.**


### personal pronouns 
Avoid “you” and “we” in favor of the specific role performing the task or the imperative mood, but do not use the passive voice if “you” would be simpler.

* *Bad*: We will start by creating credentials for you.
* **_Good_: To start, create credentials for the super admin.**
* *Bad*: Log in with the password that was set during migrations.
* **_Good_: Log in with the password you set during migrations.**

### Plugin
Use proper case

### Role
Use proper case

### Role-Based Access Control, RBAC
Use proper case, introduce full phrase only once per section, use abbreviation after

### Routes
Use proper case

### serial comma 
For safety, clarity, and sanity

### setup, set up
Joined as a noun/modifier, separated as a phrasal verb, joined as a noun/modifier, separated as a phrasal verb

* A protocol is required to *set up* a service.
* To learn more, visit the account *setup* guide.  

### Services
Use proper case

### Super Admin
Lowercase; no hyphen even as a compound modifier

* Invite a *Super Admin*.
* Grant the new consumer *Super Admin* permissions.

### text in buttons, links
Maintain the case, surround with double quotes

* Click “Admins” in the sidebar.

* Use the “Add Role” button.

### titles
Prepositions and articles are lower case, everything else is proper case

* Create RBAC Roles for an Admin in the New Workspace

### utilize
Has a specific meaning, “to use what is available”; it should not be used a fancy synonym for “use”

* *Bad*: The Admin may *utilize* the feature to observe traffic.
* **_Good_: The Admin may *use* the feature to observe traffic.**

### Vitals
Use proper case

### Workspace, Workspaces
Use proper case
