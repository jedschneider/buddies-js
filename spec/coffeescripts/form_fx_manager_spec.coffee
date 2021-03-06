describe "FormFxManager", ->
  el = atts = spy = null
  setup = (el, atts)->
    @el = el
    runs ->
      FormFxManager.registerListeners(el, atts)
      $("body").append(el)
    waitsFor( (-> $('#myform').is(':visible') ), 1000, "form to be visible")

  after = -> $('#myform').remove()

  foo = -> $(el).find(':input[name="foo"]')

  bar = -> $(el).find(':input[name="bar"]')

  gary = -> $(el).find(':input[name="gary"]')

  jed = -> $(el).find(':input[name="jed"]')

  check_foo = ->
    runs ->
      expect( foo() ).toBeVisible()
      expect( bar() ).not.toBeVisible()
      foo().prop("checked", true).change()
    waitsFor((-> bar().is(':visible')), 1000, "bar should be visible")

  uncheck_foo = ->
    runs ->
      foo().prop("checked", false).change()
    waits 10

  check_foo_and_bar = ->
    check_foo()
    runs ->
      bar().prop('checked', true).change()
    waitsFor((-> bar().is(':visible')), 1000, "bar should be visible")

  describe "a checkbox", ->

    describe "the simple case", ->

      beforeEach ->
        el = $("
        <form id='myform'>
          <input type='checkbox' name='foo' >
          </input><input type='text' name='bar' style='display:none;'></input>
        </form>")
        atts = {'foo' : {'true' : ['bar']}}
        setup(el, atts)

      afterEach -> after()

      it "should register a listener and display on checked", ->
        check_foo()
        runs ->
          expect( bar() ).toBeVisible()

      it "should register a listener and hide on unchecked", ->
        check_foo() ; uncheck_foo() ; waits 1
        runs ->
          expect( bar() ).toBeHidden()

    describe "a dependent input", ->
      beforeEach ->
        el = $("
        <form id='myform'>
          <input type='checkbox' name='foo' >
          </input><input type='text' name='bar'></input>
          <input type='text' name='jed'></input>
          <input type='text' name='gary'></input>
        </form>")
        atts = {'foo' : {'true' : ['bar', 'jed'], 'false' : ['gary']} }
        setup(el, atts)

      afterEach -> after()

      it "should not show the inputs indicated in the false values", ->
        runs ->
          expect( bar() ).not.toBeVisible()
          expect( jed() ).not.toBeVisible()
          expect( gary() ).toBeVisible()
        check_foo()
        runs ->
          expect( gary() ).toBeHidden()

    describe "a nested dependency", ->
      beforeEach ->
        el = $("
          <form id='myform'>
            <input type='checkbox' name='foo' ></input>
            <input type='checkbox' name='bar'></input>
            <input type='text' name='jed'></input>
            <input type='text' name='gary'></input>
          </form>")
        atts =
          'foo' :
            'true' : ['bar']
          'bar' :
            'true' : ['gary']
        setup(el, atts)

      afterEach -> after()

      it "should start with gary hidden", ->
        runs ->
          expect( gary() ).toBeHidden()

      it "should not show gary when foo is checked", ->
        check_foo()
        waitsFor((-> bar().is(':visible')), 1000, "bar should be visible")
        runs ->
          expect( gary() ).toBeHidden()

      it "should show bar when foo is checked then gary when bar is checked", ->
        check_foo_and_bar()
        runs ->
          expect( gary() ).toBeVisible()

    describe "a different nested dependency", ->
      beforeEach ->
        el = $("
          <form id='myform'>
            <input type='checkbox' name='foo' ></input>
            <input type='checkbox' name='bar'></input>
            <input type='text' name='jed'></input>
            <input type='text' name='gary'></input>
          </form>")
        atts =
          'foo' :
            'true' : ['bar']
          'bar' :
            'false' : ['gary']
        setup(el, atts)

      afterEach -> after()

      it "should start with gary hidden", ->
        runs ->
          expect( gary() ).toBeHidden()

      it "should show gary when foo is checked", ->
        check_foo()
        waitsFor((-> bar().is(':visible')), 1000, "bar should be visible")
        runs ->
          expect( gary() ).toBeVisible()

      it "should show bar when foo is checked then hide gary when bar is checked", ->
        check_foo_and_bar()
        runs ->
          expect( gary() ).toBeHidden()

  describe "a select tag", ->
    baz = -> $(el).find(':input[name="baz"]')
    select_bar = ->
      runs ->
        expect( baz() ).toBeHidden()
        $(el).find("select").val('bar').change()
      waitsFor((-> baz().is(':visible')), 1000, 'baz to be visible')

    beforeEach ->
      el = $("
        <form id='myform'>
          <select name='funding_source'>
            <option>Pick an option</option>
            <option value='foo'>Foo</option>
            <option value='bar'>Bar</option>
          </select>
          <input type='text' name='baz'></input>
          <input type='text' name='biz'></input>
        </form>")
      atts = {'funding_source' : {'bar' : ['baz']}}
      setup(el,atts)

    afterEach -> after()

    describe "when bar is selected", ->
      it "should have the right option selected", ->
        select_bar()
        runs -> expect( $(el).find('select') ).toHaveValue 'bar'

      it "should show baz", ->
        select_bar()
        runs -> expect( $(el).find(':input[name="baz"]') ).toBeVisible()

      it "should always show biz", ->
        expectation = -> expect( $(el).find(':input[name="biz"]') ).toBeVisible()
        runs expectation ; select_bar() ; runs expectation
        
    describe "when bar is not selected", ->
      it "should hide baz", ->
        select_bar()
        runs ->
          $(el).find('select').val('foo').change()
        waitsFor((-> baz().is(':hidden')), 1000, 'baz to be hidden')
        runs -> expect(true).toBeTruthy() #=> jasmine hack

  describe "a text field", ->
    fill_in_baz = (stuff)-> $(el).find(":input[name='baz']").val("fizzle").change()
    beforeEach ->
      el = $("
        <form id='myform'>
          <input type='text' name='baz'></input>
          <input type='text' name='biz'></input>
        </form>")
      atts = {baz : {'true' : ['biz'] }}
      setup(el, atts)
    afterEach -> after()

    it "should show a dependent input when the input has text", ->
      waits 10
      runs ->
        expect( $(el).find(":input[name='biz']") ).toBeHidden()
      waits 1
      runs fill_in_baz
      waitsFor( (-> $(el).find(":input[name='biz']").is(":visible")), 1000, "biz to be visible")
      runs -> expect(true).toBeTruthy() #=> jasmine hack

  describe "for a class name", ->
    beforeEach ->
      el = $('
        <form id="myform">
          <input name="foo" type="text"></input>
          <div class="boo bar">
            <input name="bar" type="text"></input>
          </div>
        </form>')
      atts = {foo : {'true' : ['.bar']}}
      setup(el,atts)

    afterEach -> after()

    it "should hide the element with the giving class", ->
      runs ->
        expect( $(el).find("div.bar") ).toBeHidden()
        foo().val("fizzle").change()
      waitsFor((-> bar().is(":visible")), 1000, "bar to be visible")
      runs ->
        expect( $(el).find("div.bar") ).toBeVisible()
