---
title: buddies.js
layout : default
---

Some useful tools for dynamic html user forms written in CoffeeScript, available in CoffeeScript or JavaScript.

Users like dynamic forms, but often in the development process, there is a bleeding of responsibility between getting data out of the form and display. buddies.js tries to solve this by providing two namespaces that work together to accomplish this task, but maintains a clear line in the sand between these two needs.

Secondly, these two classes intend to remove the vast majority of logic based watchers that tend to add up in dynamic user forms. For Example: if this value is selected in form element foo, then show bar, otherwise show baz.

Data as code. The nature of this dynamic form building makes it really difficult to follow and respond to changes in stakeholder requirements. Instead of representing these imperatively in code, this project represents the relationships with data. It makes for some fairly opinionated assumptions about this process, but provide some unique options to support various constructs. See usage and specs for specific examples.

This code was extracted from a fairly large and complicated backbone.js app where this type of form interaction was fairly common. It probably works well in any javascript framework, but its been battle testing in backbone.
