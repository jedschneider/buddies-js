describe("FormFxManager", function() {
  var after, atts, bar, check_foo, check_foo_and_bar, el, foo, gary, jed, setup, spy, uncheck_foo;
  el = atts = spy = null;
  setup = function(el, atts) {
    this.el = el;
    runs(function() {
      FormFxManager.registerListeners(el, atts);
      return $("body").append(el);
    });
    return waitsFor((function() {
      return $('#myform').is(':visible');
    }), 1000, "form to be visible");
  };
  after = function() {
    return $('#myform').remove();
  };
  foo = function() {
    return $(el).find(':input[name="foo"]');
  };
  bar = function() {
    return $(el).find(':input[name="bar"]');
  };
  gary = function() {
    return $(el).find(':input[name="gary"]');
  };
  jed = function() {
    return $(el).find(':input[name="jed"]');
  };
  check_foo = function() {
    runs(function() {
      expect(foo()).toBeVisible();
      expect(bar()).not.toBeVisible();
      return foo().prop("checked", true).change();
    });
    return waitsFor((function() {
      return bar().is(':visible');
    }), 1000, "bar should be visible");
  };
  uncheck_foo = function() {
    runs(function() {
      return foo().prop("checked", false).change();
    });
    return waits(10);
  };
  check_foo_and_bar = function() {
    check_foo();
    runs(function() {
      return bar().prop('checked', true).change();
    });
    return waitsFor((function() {
      return bar().is(':visible');
    }), 1000, "bar should be visible");
  };
  describe("a checkbox", function() {
    describe("the simple case", function() {
      beforeEach(function() {
        el = $("        <form id='myform'>          <input type='checkbox' name='foo' >          </input><input type='text' name='bar' style='display:none;'></input>        </form>");
        atts = {
          'foo': {
            'true': ['bar']
          }
        };
        return setup(el, atts);
      });
      afterEach(function() {
        return after();
      });
      it("should register a listener and display on checked", function() {
        check_foo();
        return runs(function() {
          return expect(bar()).toBeVisible();
        });
      });
      return it("should register a listener and hide on unchecked", function() {
        check_foo();
        uncheck_foo();
        waits(1);
        return runs(function() {
          return expect(bar()).toBeHidden();
        });
      });
    });
    describe("a dependent input", function() {
      beforeEach(function() {
        el = $("        <form id='myform'>          <input type='checkbox' name='foo' >          </input><input type='text' name='bar'></input>          <input type='text' name='jed'></input>          <input type='text' name='gary'></input>        </form>");
        atts = {
          'foo': {
            'true': ['bar', 'jed'],
            'false': ['gary']
          }
        };
        return setup(el, atts);
      });
      afterEach(function() {
        return after();
      });
      return it("should not show the inputs indicated in the false values", function() {
        runs(function() {
          expect(bar()).not.toBeVisible();
          expect(jed()).not.toBeVisible();
          return expect(gary()).toBeVisible();
        });
        check_foo();
        return runs(function() {
          return expect(gary()).toBeHidden();
        });
      });
    });
    describe("a nested dependency", function() {
      beforeEach(function() {
        el = $("          <form id='myform'>            <input type='checkbox' name='foo' ></input>            <input type='checkbox' name='bar'></input>            <input type='text' name='jed'></input>            <input type='text' name='gary'></input>          </form>");
        atts = {
          'foo': {
            'true': ['bar']
          },
          'bar': {
            'true': ['gary']
          }
        };
        return setup(el, atts);
      });
      afterEach(function() {
        return after();
      });
      it("should start with gary hidden", function() {
        return runs(function() {
          return expect(gary()).toBeHidden();
        });
      });
      it("should not show gary when foo is checked", function() {
        check_foo();
        waitsFor((function() {
          return bar().is(':visible');
        }), 1000, "bar should be visible");
        return runs(function() {
          return expect(gary()).toBeHidden();
        });
      });
      return it("should show bar when foo is checked then gary when bar is checked", function() {
        check_foo_and_bar();
        return runs(function() {
          return expect(gary()).toBeVisible();
        });
      });
    });
    return describe("a different nested dependency", function() {
      beforeEach(function() {
        el = $("          <form id='myform'>            <input type='checkbox' name='foo' ></input>            <input type='checkbox' name='bar'></input>            <input type='text' name='jed'></input>            <input type='text' name='gary'></input>          </form>");
        atts = {
          'foo': {
            'true': ['bar']
          },
          'bar': {
            'false': ['gary']
          }
        };
        return setup(el, atts);
      });
      afterEach(function() {
        return after();
      });
      it("should start with gary hidden", function() {
        return runs(function() {
          return expect(gary()).toBeHidden();
        });
      });
      it("should show gary when foo is checked", function() {
        check_foo();
        waitsFor((function() {
          return bar().is(':visible');
        }), 1000, "bar should be visible");
        return runs(function() {
          return expect(gary()).toBeVisible();
        });
      });
      return it("should show bar when foo is checked then hide gary when bar is checked", function() {
        check_foo_and_bar();
        return runs(function() {
          return expect(gary()).toBeHidden();
        });
      });
    });
  });
  describe("a select tag", function() {
    var baz, select_bar;
    baz = function() {
      return $(el).find(':input[name="baz"]');
    };
    select_bar = function() {
      runs(function() {
        expect(baz()).toBeHidden();
        return $(el).find("select").val('bar').change();
      });
      return waitsFor((function() {
        return baz().is(':visible');
      }), 1000, 'baz to be visible');
    };
    beforeEach(function() {
      el = $("        <form id='myform'>          <select name='funding_source'>            <option>Pick an option</option>            <option value='foo'>Foo</option>            <option value='bar'>Bar</option>          </select>          <input type='text' name='baz'></input>          <input type='text' name='biz'></input>        </form>");
      atts = {
        'funding_source': {
          'bar': ['baz']
        }
      };
      return setup(el, atts);
    });
    afterEach(function() {
      return after();
    });
    describe("when bar is selected", function() {
      it("should have the right option selected", function() {
        select_bar();
        return runs(function() {
          return expect($(el).find('select')).toHaveValue('bar');
        });
      });
      it("should show baz", function() {
        select_bar();
        return runs(function() {
          return expect($(el).find(':input[name="baz"]')).toBeVisible();
        });
      });
      return it("should always show biz", function() {
        var expectation;
        expectation = function() {
          return expect($(el).find(':input[name="biz"]')).toBeVisible();
        };
        runs(expectation);
        select_bar();
        return runs(expectation);
      });
    });
    return describe("when bar is not selected", function() {
      return it("should hide baz", function() {
        select_bar();
        runs(function() {
          return $(el).find('select').val('foo').change();
        });
        waitsFor((function() {
          return baz().is(':hidden');
        }), 1000, 'baz to be hidden');
        return runs(function() {
          return expect(true).toBeTruthy();
        });
      });
    });
  });
  describe("a text field", function() {
    var fill_in_baz;
    fill_in_baz = function(stuff) {
      return $(el).find(":input[name='baz']").val("fizzle").change();
    };
    beforeEach(function() {
      el = $("        <form id='myform'>          <input type='text' name='baz'></input>          <input type='text' name='biz'></input>        </form>");
      atts = {
        baz: {
          'true': ['biz']
        }
      };
      return setup(el, atts);
    });
    afterEach(function() {
      return after();
    });
    return it("should show a dependent input when the input has text", function() {
      waits(10);
      runs(function() {
        return expect($(el).find(":input[name='biz']")).toBeHidden();
      });
      waits(1);
      runs(fill_in_baz);
      waitsFor((function() {
        return $(el).find(":input[name='biz']").is(":visible");
      }), 1000, "biz to be visible");
      return runs(function() {
        return expect(true).toBeTruthy();
      });
    });
  });
  return describe("for a class name", function() {
    beforeEach(function() {
      el = $('\
        <form id="myform">\
          <input name="foo" type="text"></input>\
          <div class="boo bar">\
            <input name="bar" type="text"></input>\
          </div>\
        </form>');
      atts = {
        foo: {
          'true': ['.bar']
        }
      };
      return setup(el, atts);
    });
    afterEach(function() {
      return after();
    });
    return it("should hide the element with the giving class", function() {
      runs(function() {
        expect($(el).find("div.bar")).toBeHidden();
        return foo().val("fizzle").change();
      });
      waitsFor((function() {
        return bar().is(":visible");
      }), 1000, "bar to be visible");
      return runs(function() {
        return expect($(el).find("div.bar")).toBeVisible();
      });
    });
  });
});