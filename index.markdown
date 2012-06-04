---
title: buddies.js
layout : default
---

## The Gist ##

Users like dynamic forms, but often in the development process, there is a bleeding of responsibility between getting data out of the form and display. buddies.js tries to solve this by providing two namespaces that work together to accomplish this task, but maintains a clear line in the sand between these two needs.

Secondly, these two namespaces (FormManager and FormFxManager) intend to remove the vast majority of logic based watchers that tend to add up in dynamic user forms. For Example: if this value is selected in form element foo, then show bar, otherwise show baz.

## Example ##

Lets say that you have a [billing and shipping address form](#form_example) and you want to only gather data for the shipping address if the addresses are not the same. A checkbox determines if the user sees one or two address inputs. There are two issues, the first is setting and getting the data with [FormManager](#formmanager), the second is hiding or showing the shipping address with [FormFxManager](#formfxmanager) based on the value of the checkbox. 

{% highlight html %}
{% include form.html %}
{% endhighlight %}


### FormManager ###

*Getting and Setting Data*

First, You declare the relationships between your object and the form elements. Each key is an object attribute, each value is the name attribute of the form input. Notice with the first two attributes, the shorthand notation is used, but in the last attribute `shipping_address` the longhand notation is used. The `require_visible` option requires the input to be in a visible state before extracting the data from it. This is helpful if you want to assume that data left in a hidden field is not intended to be the 'right' choice by the user.

{% highlight javascript %}
{% include attributes.js %}
{% endhighlight %}

To send data to the form, you construct an object to pass to the form:

{% highlight javascript %}
{% include my_ob.js %}
{% endhighlight %}

And then finally you use `FormManager` to populate the form:

{% highlight javascript %}
{% include populate.js %}
{% endhighlight %}

To get the data back out of the form, you call extract.

{% highlight javascript %}
{% include extract.js %}
{% endhighlight %}

### FormFxManager ###

`FormFxManager` deals with showing and hiding inputs based on a set of declared dependencies. The original idea was to get away from trying to handle each condition separately. This came out of our experience trying to stay in sync with the stakeholder about what inputs should be visible based on a set of business logic decisions. Trying to manage that process by declaring the business logic in code became tedious and slow to test. Instead we rely on data to declare the relationships.

{% highlight javascript %}
{% include fxmanager.js %}
{% endhighlight %}

<script type="text/javascript" charset="utf-8">
  $(document).ready(function(){
    {% include attributes.js %}
    {% include my_ob.js %}
    {% include populate.js %}
    {% include fxmanager.js %}
    $("#submit").click(function(e){
      {% include extract.js %}
      alert("return object:\n" + JSON.stringify(new_attributes, undefined, 2));
      return false;
    })
  });
</script>

<style type="text/css" media="screen">
  form {
    background-color : #ccc;
    margin: 0px 20px 0px 20px;
    padding: 5px;}
</style>

### Form Example ###
Play with the field and click Extract to view the extracted object.
{% include form.html %}

---
## Similar Libraries ##

The idea here is similar to [jQuery#serialize](http://api.jquery.com/serialize/) except that serialize expects the data to be immediately ajaxed. buddies-js expects that you might want to manage the data client side for validation or other valid business concerns before trying to post to the server. [Backbone.Syphon](https://github.com/derickbailey/backbone.syphon) is also quite similar but specific to Backbone.js and may not support some of the features like nested attributes that this project does.

## Next Steps ##

See the [README](https://github.com/HSSC/buddies-js) in the source, and then look in the spec directory for more explicit examples involving [formatting functions](https://github.com/HSSC/buddies-js/blob/master/spec/coffeescripts/form_manager_spec.coffee#L64), [nested attributes](https://github.com/HSSC/buddies-js/blob/master/spec/coffeescripts/form_fx_manager_spec.coffee#L86), and [data types](https://github.com/HSSC/buddies-js/blob/master/spec/coffeescripts/form_manager_spec.coffee#L64).
