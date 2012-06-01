---
title: buddies.js
layout : default
---

Some useful tools for dynamic html user forms written in CoffeeScript, available in CoffeeScript or JavaScript.

Users like dynamic forms, but often in the development process, there is a bleeding of responsibility between getting data out of the form and display. buddies.js tries to solve this by providing two namespaces that work together to accomplish this task, but maintains a clear line in the sand between these two needs.

Secondly, these two classes intend to remove the vast majority of logic based watchers that tend to add up in dynamic user forms. For Example: if this value is selected in form element foo, then show bar, otherwise show baz.

## Example

Lets say that you have a billing and shipping address form and you want to only gather data for the shipping address if the addresses are not the same. There are two issues, the first is setting and getting the data with [FormMananger](#formmanager), the second is hiding the shipping address if the addresses are the same. 

{% highlight html %}
{% include form.html %}
{% endhighlight %}


### FormManager

*Getting and Setting Data*

First, You declare the relationships between your object and the form elements. Each key is an object attribute, each value is the name attribute of the form input.

{% highlight javascript %}
{% include attributes.js %}
{% endhighlight %}

To send data to the form, you can pass an object to the form:

{% highlight javascript %}
{% include my_ob.js %}
{% endhighlight %}

And then finally you use FormManager to populate the form:

{% highlight javascript %}
{% include populate.js %}
{% endhighlight %}

<script type="text/javascript" charset="utf-8">
  $(document).ready(function(){
    {% include attributes.js %}
    {% include my_ob.js %}
    {% include populate.js %}
  });
</script>

<style type="text/css" media="screen">
  form {
    background-color : #ccc;
    margin: 0px 20px 0px 20px;
    padding: 5px;}
</style>
{% include form.html %}

---
## Longer Explanation

Data as code. The nature of this dynamic form building makes it really difficult to follow and respond to changes in stakeholder requirements. Instead of representing these imperatively in code, this project represents the relationships with data. It makes for some fairly opinionated assumptions about this process, but provide some unique options to support various constructs. See usage and specs for specific examples.

This code was extracted from a fairly large and complicated backbone.js app where this type of form interaction was fairly common. It probably works well in any javascript framework, but its been battle testing in backbone.
