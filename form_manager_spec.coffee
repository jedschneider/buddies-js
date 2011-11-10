describe "FormManager", ->
  el = atts = ob = fm = null
  describe "populateForm", ->
    describe "using a name attribute", ->
      describe "basic functionality", ->
        beforeEach ->
          atts =
            short_title :
              selector : 'short-title'
          ob = {short_title : "Foo"}

        it "should find the DOM element when the key and value are different", ->
          el = $("<form><input type='text' name='short-title'></input></form>")
          FormManager.populateForm ob, el, atts

          expect( $(el).find(":input") ).toHaveValue "Foo"

        it "should not find the DOM element when the value is similar", ->
          el = $("<form><input type='text' name='short-title-longer'></input></form>")

          expect( -> FormManager.populateForm(ob, el, atts) ).toThrow()

        it "should allow the default implementation of a string for a selector", ->
          el = $("<form><input type='text' name='short-title'></input></form>")
          atts = {short_title : 'short-title'}
          FormManager.populateForm ob, el, atts

          expect( $(el).find(":input") ).toHaveValue "Foo"

      describe "taking an option to only find visible elements", ->
        input       = -> $(el).find(':input[name="long-title"]')
        other_input = -> $(el).find(':input[name="short-title"]')

        beforeEach ->
          ob = {short_title : "Foo", long_title : "bar"}
          atts =
            short_title :
              selector : 'short-title'
              require_visible : false
            long_title :
              selector : 'long-title'
              require_visible : true
          el = $("
            <form id='myform'>
              <input name='short-title' style='display: inline;'></input>
              <input name='long-title' style='display: inline;'></input>
            </form>")
          FormManager.populateForm ob, el, atts
          $("body").append(el)

        afterEach ->
          $('#myform').remove()

        it "should not set the hidden input when require_visible : true", ->
          runs ->
            input().hide()
          waitsFor((-> input().is(':hidden')), 1000, "input is hidden")
          runs ->
            foo = FormManager.extract(el, atts)

            expect(foo.long_title).toBeUndefined()
            expect(foo.short_title).toEqual ob.short_title

        it "should set the hidden input when require_visible : false", ->
          runs ->
            expect( other_input() ).toBeVisible()
            other_input().hide()
          waitsFor((-> other_input().is(':hidden')), 1000, 'other input to be hidden')
          runs ->

            expect( FormManager.extract(el, atts).short_title ).toEqual "Foo"

      describe "for a text field", ->
        beforeEach ->
          el = $("<form><input type='text' name='short-title'></input></form>")
          atts =
            short_title :
              selector : 'short-title'
          ob = {short_title : "Foo"}
          FormManager.populateForm ob, el, atts

        it "should populate form", ->
          expect( $(el).find(":input") ).toHaveValue "Foo"

        it "should extract from the form", ->
          expect( FormManager.extract(el, atts).short_title ).toEqual "Foo"

      describe "for a checkbox", ->
        beforeEach ->
          el = $("<form><input type='checkbox' name='checker'></input><form>")
          atts = {checker : {selector: 'checker'}}
          ob = {checker : true}
          FormManager.populateForm ob, el, atts

        it "should populate the form", ->
          expect( $(el).find(":input") ).toBeChecked()

        it "should get the value from the checkbox", ->
          expect( FormManager.extract(el, atts).checker ).toEqual true

      describe "populating a select input", ->
        beforeEach ->
          el = $("<form><select name='zat'>
            <option>Select Something</option>
            <option value='that'>That</option>
            </input></form>")
          atts = {zat : {selector : 'zat'}}
          ob = {zat : 'that'}
          FormManager.populateForm ob, el, atts

        it "should populate the form with the appropriate option selected", ->
          expect( $(el).find('option[value=that]') ).toBeSelected()

        it "should get the selected option from the select tag", ->
          expect( FormManager.extract(el, atts).zat ).toEqual ob.zat

    describe "using a class attribute", ->
      beforeEach ->
        el = $("<form><input class='info' type='text' name='short-title'></input></form>")
        atts = {short_title : {selector : ".info"}}
        ob = {short_title : "Bar"}
        FormManager.populateForm ob, el, atts

      it "should find the DOM element and populate the form", ->
        expect( $(el).find(".info") ).toHaveValue "Bar"

      it "should get the value from the DOM element", ->
        expect( FormManager.extract(el, atts).short_title ).toEqual "Bar"

    describe "using an id attribute", ->
      beforeEach ->
        el = $("<form><input id='info' type='text' name='short-title'></input></form>")
        atts = {short_title : {selector : '#info'}}
        ob = {short_title : "Bar"}
        FormManager.populateForm ob, el, atts

      it "should find the DOM element and populuate the form", ->
        expect( $(el).find("#info") ).toHaveValue "Bar"

      it "should get the value from the DOM element", ->
        expect( FormManager.extract(el, atts).short_title ).toEqual "Bar"