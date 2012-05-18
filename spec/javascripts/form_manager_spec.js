describe("FormManager", function() {
  var atts, el, fm, ob;
  el = atts = ob = fm = null;
  describe("populateForm", function() {
    return describe("using a name attribute", function() {
      describe("basic functionality", function() {
        beforeEach(function() {
          atts = {
            short_title: {
              selector: 'short-title'
            }
          };
          return ob = {
            short_title: "Foo"
          };
        });
        it("should find the DOM element when the key and value are different", function() {
          el = $("<form><input type='text' name='short-title'></input></form>");
          FormManager.populateForm(ob, el, atts);
          return expect($(el).find(":input")).toHaveValue("Foo");
        });
        it("should not find the DOM element when the value is similar", function() {
          el = $("<form><input type='text' name='short-title-longer'></input></form>");
          return expect(function() {
            return FormManager.populateForm(ob, el, atts);
          }).toThrow();
        });
        return it("should allow the default implementation of a string for a selector", function() {
          el = $("<form><input type='text' name='short-title'></input></form>");
          atts = {
            short_title: 'short-title'
          };
          FormManager.populateForm(ob, el, atts);
          return expect($(el).find(":input")).toHaveValue("Foo");
        });
      });
      describe("data_type option", function() {
        beforeEach(function() {
          atts = {
            some_number: {
              selector: 'some-number',
              data_type: 'number'
            },
            some_integer: {
              selector: 'some-integer',
              data_type: 'integer'
            }
          };
          return el = $("<form>\n  <input type='text' name='some-number'></input>\n  <input type='text' name='some-integer'></input>\n</form>");
        });
        describe("number", function() {
          it("should set an empty field to zero", function() {
            return expect(_.isNumber(FormManager.extract(el, atts).some_number)).toBeTruthy();
          });
          return it("should use the number in the field if it got it", function() {
            el.find(':input[name=some-number]').val('12');
            return expect(FormManager.extract(el, atts).some_number).toEqual(12);
          });
        });
        describe("integer", function() {
          it("should not return a float", function() {
            el.find(':input[name=some-integer]').val('8.5');
            return expect(FormManager.extract(el, atts).some_integer).not.toEqual(8.5);
          });
          return it("should return an integer", function() {
            var val;
            el.find(':input[name=some-integer]').val('78');
            val = FormManager.extract(el, atts).some_integer;
            expect(_.isNumber(val)).toBeTruthy();
            return expect(val).toEqual(78);
          });
        });
        return describe("date", function() {
          beforeEach(function() {
            return atts = {
              some_date: {
                selector: 'some-date',
                formatter: {
                  to_form: function(from_ob) {
                    var day, garbage, month, year, _ref;
                    _ref = from_ob.match(/(\d{4})-(\d\d)-(\d\d)/), garbage = _ref[0], year = _ref[1], month = _ref[2], day = _ref[3];
                    return "" + month + "/" + day + "/" + year;
                  },
                  from_form: function(input) {
                    var day, garbage, month, year, _ref;
                    _ref = input.match(/(\d\d)\/(\d\d)\/(\d{4})/), garbage = _ref[0], month = _ref[1], day = _ref[2], year = _ref[3];
                    return "" + year + "-" + month + "-" + day;
                  }
                }
              }
            };
          });
          it("should populate the form with the provided format", function() {
            ob = {
              some_date: "2011-12-01"
            };
            el = $("<form>                      <input type='text' name='some-date'></input>                    </form>");
            FormManager.populateForm(ob, el, atts);
            return expect($(el).find(':input')).toHaveValue("12/01/2011");
          });
          return it("should extract a date in the provided format", function() {
            el = $("<form>                      <input type='text' name='some-date' value='12/01/2011'>12/01/2011</input>                    </form>");
            return expect(FormManager.extract(el, atts).some_date).toEqual("2011-12-01");
          });
        });
      });
      describe("nested attribute functionality for checkboxes", function() {
        beforeEach(function() {
          atts = {
            pets: {
              selector: 'pets',
              is_nested: true
            }
          };
          ob = {
            pets: {
              dogs: true,
              cats: true,
              birds: false
            }
          };
          el = $("<form id='myform'>                    <input type='checkbox' name='pets[dogs]'></input>                    <input type='checkbox' name='pets[cats]'></input>                    <input type='checkbox' name='pets[birds]'></input>                  </form>");
          return FormManager.populateForm(ob, el, atts);
        });
        it("should populate the form with nested attributes", function() {
          return expect($(el).find(":checked").length).toEqual(2);
        });
        return it("should extract the attributes from the form", function() {
          return expect(FormManager.extract(el, atts).pets).toEqual(ob.pets);
        });
      });
      describe("nested attribute functionality for select tags", function() {
        beforeEach(function() {
          atts = {
            pets: {
              selector: 'pets',
              is_nested: true
            }
          };
          ob = {
            pets: {
              dogs: 'beagle',
              birds: "cockatoo"
            }
          };
          el = $("            <form id='myform'>              <select name='pets[dogs]'>                <option>Select a Dog</option>                <option value='beagle'>Beagle</option>                <option value='coonhound'>Coonhound</option>              </select>              <select name='pets[birds]'>                <option>Select A Bird</option>                <option value='macaw'>Macaw</option>                <option value='cockatoo'>Cockatoo</option>              </select>            </form>");
          return FormManager.populateForm(ob, el, atts);
        });
        it("should fill out the form", function() {
          expect(el.find('select[name="pets[dogs]"] option[value="beagle"]')).toBeSelected();
          return expect(el.find('select[name="pets[birds]"] option[value="cockatoo"]')).toBeSelected();
        });
        return it("should get it from the form", function() {
          return expect(FormManager.extract(el, atts).pets).toEqual(ob.pets);
        });
      });
      return describe("taking an option to only find visible elements", function() {
        var input, other_input;
        input = function() {
          return $(el).find(':input[name="long-title"]');
        };
        other_input = function() {
          return $(el).find(':input[name="short-title"]');
        };
        beforeEach(function() {
          ob = {
            short_title: "Foo",
            long_title: "bar"
          };
          atts = {
            short_title: {
              selector: 'short-title',
              require_visible: false
            },
            long_title: {
              selector: 'long-title',
              require_visible: true
            }
          };
          el = $("            <form id='myform'>              <input name='short-title' style='display: inline;'></input>              <input name='long-title' style='display: inline;'></input>            </form>");
          FormManager.populateForm(ob, el, atts);
          return $("body").append(el);
        });
        afterEach(function() {
          return $('#myform').remove();
        });
        it("should not set the hidden input when require_visible : true", function() {
          runs(function() {
            return input().hide();
          });
          waitsFor((function() {
            return input().is(':hidden');
          }), 1000, "input is hidden");
          return runs(function() {
            var foo;
            foo = FormManager.extract(el, atts);
            expect(foo.long_title).toBeUndefined();
            return expect(foo.short_title).toEqual(ob.short_title);
          });
        });
        return it("should set the hidden input when require_visible : false", function() {
          runs(function() {
            expect(other_input()).toBeVisible();
            return other_input().hide();
          });
          waitsFor((function() {
            return other_input().is(':hidden');
          }), 1000, 'other input to be hidden');
          return runs(function() {
            return expect(FormManager.extract(el, atts).short_title).toEqual("Foo");
          });
        });
      });
    });
  });
  describe("for a text field", function() {
    beforeEach(function() {
      el = $("<form><input type='text' name='short-title'></input></form>");
      atts = {
        short_title: {
          selector: 'short-title'
        }
      };
      ob = {
        short_title: "Foo"
      };
      return FormManager.populateForm(ob, el, atts);
    });
    it("should populate form", function() {
      return expect($(el).find(":input")).toHaveValue("Foo");
    });
    return it("should extract from the form", function() {
      return expect(FormManager.extract(el, atts).short_title).toEqual("Foo");
    });
  });
  describe("for a textarea", function() {
    beforeEach(function() {
      el = $("<form><textarea name='short-title'></textarea></form>");
      atts = {
        short_title: {
          selector: 'short-title'
        }
      };
      ob = {
        short_title: "Foo"
      };
      return FormManager.populateForm(ob, el, atts);
    });
    it("should populate form", function() {
      return expect($(el).find("textarea[name=short-title]")).toHaveValue("Foo");
    });
    return it("should extract from the form", function() {
      return expect(FormManager.extract(el, atts).short_title).toEqual("Foo");
    });
  });
  describe("for a checkbox", function() {
    beforeEach(function() {
      el = $("<form><input type='checkbox' name='checker'></input></form>");
      atts = {
        checker: {
          selector: 'checker'
        }
      };
      ob = {
        checker: true
      };
      return FormManager.populateForm(ob, el, atts);
    });
    it("should populate the form", function() {
      return expect($(el).find(":input")).toBeChecked();
    });
    return it("should get the value from the checkbox", function() {
      return expect(FormManager.extract(el, atts).checker).toEqual(true);
    });
  });
  describe("populating a select input", function() {
    beforeEach(function() {
      el = $("<form><select name='zat'>        <option>Select Something</option>        <option value='that'>That</option>        </input></form>");
      atts = {
        zat: {
          selector: 'zat'
        }
      };
      ob = {
        zat: 'that'
      };
      return FormManager.populateForm(ob, el, atts);
    });
    it("should populate the form with the appropriate option selected", function() {
      return expect($(el).find('option[value=that]')).toBeSelected();
    });
    return it("should get the selected option from the select tag", function() {
      return expect(FormManager.extract(el, atts).zat).toEqual(ob.zat);
    });
  });
  describe("ingoring an input with the default value defined", function() {
    beforeEach(function() {
      el = $("<form>              <select name='pets'>                <option>Select A Pet</option>                <option value='beagle'>Beagle</option>                <option value='cockatoo'>Cockatoo</option>                <option>Appliances</option>                <option value='microwave'>Microwave</option>              </select>              </form>");
      return atts = {
        pets: {
          selector: 'pets'
        }
      };
    });
    return it("should not use the default text of the first option as data", function() {
      return expect(FormManager.extract(el, atts).pets).toBeUndefined();
    });
  });
  describe("using a class attribute", function() {
    beforeEach(function() {
      el = $("<form><input class='info' type='text' name='short-title'></input></form>");
      atts = {
        short_title: {
          selector: ".info"
        }
      };
      ob = {
        short_title: "Bar"
      };
      return FormManager.populateForm(ob, el, atts);
    });
    it("should find the DOM element and populate the form", function() {
      return expect($(el).find(".info")).toHaveValue("Bar");
    });
    return it("should get the value from the DOM element", function() {
      return expect(FormManager.extract(el, atts).short_title).toEqual("Bar");
    });
  });
  return describe("using an id attribute", function() {
    beforeEach(function() {
      el = $("<form><input id='info' type='text' name='short-title'></input></form>");
      atts = {
        short_title: {
          selector: '#info'
        }
      };
      ob = {
        short_title: "Bar"
      };
      return FormManager.populateForm(ob, el, atts);
    });
    it("should find the DOM element and populuate the form", function() {
      return expect($(el).find("#info")).toHaveValue("Bar");
    });
    return it("should get the value from the DOM element", function() {
      return expect(FormManager.extract(el, atts).short_title).toEqual("Bar");
    });
  });
});