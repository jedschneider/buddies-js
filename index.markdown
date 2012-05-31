---
title: buddies.js
---
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="chrome=1">
  <title>Buddies-js by HSSC</title>

  <link rel="stylesheet" href="stylesheets/styles.css">
  <link rel="stylesheet" href="stylesheets/pygment_trac.css">
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
  <!--[if lt IE 9]>
  <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
</head>
<body>
  <div class="wrapper">
    <header>
      <h1>Buddies-js</h1>
      <p>A select group of javacript helpers we use to make life easier</p>
      <p class="view"><a href="https://github.com/HSSC/buddies-js">View the Project on GitHub <small>HSSC/buddies-js</small></a></p>
      <ul>
        <li><a href="https://github.com/HSSC/buddies-js/zipball/master">Download <strong>ZIP File</strong></a></li>
        <li><a href="https://github.com/HSSC/buddies-js/tarball/master">Download <strong>TAR Ball</strong></a></li>
        <li><a href="https://github.com/HSSC/buddies-js">View On <strong>GitHub</strong></a></li>
      </ul>
    </header>
<section>
# {{page.title}}

Some useful tools for dynamic html user forms written in CoffeeScript, available in CoffeeScript or JavaScript.

Users like dynamic forms, but often in the development process, there is a bleeding of responsibility between getting data out of the form and display. buddies.js tries to solve this by providing two namespaces that work together to accomplish this task, but maintains a clear line in the sand between these two needs.

Secondly, these two classes intend to remove the vast majority of logic based watchers that tend to add up in dynamic user forms. For Example: if this value is selected in form element foo, then show bar, otherwise show baz.

Data as code. The nature of this dynamic form building makes it really difficult to follow and respond to changes in stakeholder requirements. Instead of representing these imperatively in code, this project represents the relationships with data. It makes for some fairly opinionated assumptions about this process, but provide some unique options to support various constructs. See usage and specs for specific examples.

This code was extracted from a fairly large and complicated backbone.js app where this type of form interaction was fairly common. It probably works well in any javascript framework, but its been battle testing in backbone.

</section>
    <footer>
      <p>This project is maintained by <a href="https://github.com/HSSC">HSSC</a></p>
      <p><small>Hosted on GitHub Pages &mdash; Theme by <a href="https://github.com/orderedlist">orderedlist</a></small></p>
    </footer>
  </div>
  <script src="javascripts/scale.fix.js"></script>
  
</body>