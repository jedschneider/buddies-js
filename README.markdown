# buddies.js #

A collection of maybe helpful javascripts (written in coffeescript) to support form management.

Users like dynamic forms, but often in the development process, there is a bleeding of responsibility between getting data out of the form and display. buddies.js tries to solve this by providing two namespaces that work together to accomplish this task, but maintains a clear line in the sand between these two needs. 

Secondly, these two classes intend to remove the vast majority of logic based watchers that tend to add up in dynamic user forms. For Example: if this value is selected in form element foo, then show bar, otherwise show baz. 

Data as code. The nature of this dynamic form building makes it really difficult to follow and respond to changes in stakeholder requirements. Instead of representing these imperatively in code, this project represents the relationships with data. It makes for some fairly opinionated assumptions about this process, but provide some unique options to support various constructs. See usage and specs for specific examples.

This code was extracted from a fairly large and complicated backbone.js app where this type of form interaction was fairly common. It probably works well in any javascript framework, but its been battle testing in backbone.

## Requirements ##

for usage: jquery, underscrore

for testing : jquery, jasmine-jquery, underscore, jasmine

all these dependencies are in the vendor directories.

## Usage ##

If you just want to use the javascript, the compiled javascript is in the lib directory. If you want to include the coffeescript, the specific build process is up to you.

The specs provide the best list of examples for the various ways to use buddies.js. Here are a couple of short examples to get you started.

### FormManager ###

Most of the time, you just want to get the data in and out, so lets say you have a form like:

```html
<form id="foo"><input type='text' name='short-title'></input></form>
```

and you might be populating the form with data, from say, an ajax request

```coffeescript
ob = {short_title : "Foo"}
```

to set the data from this object into the form we provide a simple map that points from the object attribute to the selector name:

```coffeescript
el = $("#foo") # the html above
# use the object attribute short_title and put it in the short-title form input
atts = {short_title : 'short-title'}

FormManager.populate ob, el, atts
```

see how easy that was? Now we want to get the data back out of the form, presumably to send back via ajax on submit, or save, ..or something:

```coffeescript
$("#foo:input").val("Bar").change()
# asyncrhonus eventing, but simplifed here as if it were not, see specs for working example
my_ob = FormManager.extract(el, atts)
my_ob.short_title #=> "Bar"
```

And now, you can ajax away your new object elements.

The form manager supports nested attributes, data types, and formatting functions. See the src and specs for examples. One option to briefly touch on here is the require_visible option. It is typically assumed that you only want to persist data for elements that are visible. For example in a form where there are two options and each option has a set of sub-options, if the user fills out sub-options for option A and then changes their mind and picks option B, that the data for sub-options A are no longer desirable to persist (since the user change their mind). It may also be the case that hidden options provide real data that needs to be saved. The short hand notation above assumes visibility. The longhand form can be more specific:

```coffeescript
atts =
  short_title :
    selector : 'short-title'
    require_visible : false
```

Note, however that the longhand does not assume it knows the selector in the form form so it needs to be passed as an attribute as well. We have had the most success doing this type of data structure manipulation programatically.

### FormFxManager ###

FormFxManager handles the display state of dependent inputs based on the state of the parent input.

Example:

```coffeescript
visual_deps : {'foo' : {
                'true' : ['bar', 'baz']
               ,'false' : ['raz']}
               ,'baz' : {'scary' : 'boo'}}
```

In this case, when 'foo' (either a checkbox or a textfield, it doesn't matter) is either selected or some text is entered, the inputs 'bar' and 'baz' will be visible. Clearing the field or unchecking the box will hide those fields, but will show 'raz'. When 'foo' is checked, the manager knows that 'baz' (a select tag with an option 'scary') also has a dependency but will wait for the selected option of 'baz' to be selected before showing the dependent input 'boo'.

Using the FormFxManager just requires you tell it what the form is, and pass the dependency map:

```coffeescript
FormFxManager.registerListeners($("#myform"), visual_deps)
```

## Install ##

There is nothing really to install.

## License ##

MIT

Copyright (c) 2012 Office of Biomedical Informatics Services - MUSC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Contribute ##

Fork, and submit a pull request. We'll work with you to get you contribution included.

## Support ##

This software is released without warranty or support, that said, open an issue if you have a beef.

## Testing ##

Jasmine tests are available by loading the SpecRunner.html file into your browser.

## Credits ##

core contributors: [Jed Schneider](http://github.com/jedschneider), [Gary Fredericks](http://github.com/fredericksgary)

contributions: [Matt Scott]("http://github.com/mdms-scott"), [Andrew Cates]("https://github.com/amcates")