describe "ViewHelper", ->
  describe "money", ->
    it "should do the right thing with dollars and cents", ->
      expect( ViewHelper.money(1234) ).toEqual "$12.34"

    it "should do the right thing with cents only", ->
      expect(ViewHelper.money(34)).toEqual "$0.34"

    it "should handle 0 with $0.00", ->
      expect(ViewHelper.money(0)).toEqual "$0.00"

    it "should take an option to display as blank", ->
      display_blank = true
      expect(ViewHelper.money(0, display_blank)).toEqual ""

    it "should display the value if display_blank is true and the number has a value", ->
      display_blank = true
      expect(ViewHelper.money(1234, display_blank)).toEqual "$12.34"

    describe "fractional cents", ->
      it "should round down correctly", ->
        expect( ViewHelper.money(1483.13) ).toEqual "$14.83"

      it "should not round up to the next full cent", ->
        expect( ViewHelper.money(1483.51) ).toEqual "$14.83"

      it "should round correctly for long floats", ->
        expect( ViewHelper.money(1483.446) ).toEqual "$14.83"

  describe "date", ->
    it "should format appropriately", ->
      expect(ViewHelper.date("2011-08-31 16:45:30 UTC")).toEqual "11/08/31"

    it "should return a blank string if no string is given", ->
      expect(ViewHelper.date(null)).toEqual ""

  describe "pluralize", ->
    it "should pluralize units", ->
      expect( ViewHelper.pluralize(2, "hour") ).toEqual "2 hours"

    it "should not pluralize singular units", ->
      expect( ViewHelper.pluralize(1, "hour") ).toEqual "1 hour"

    it "should pluralize zero units", ->
      expect( ViewHelper.pluralize(0, "hour") ).toEqual "0 hours"

    it "should handle an invalid quantity factor", ->
      expect( ViewHelper.pluralize(undefined, "hour") ).toEqual "N/A"

    it "should handle an invalid unit type", ->
      expect( ViewHelper.pluralize(2, undefined) ).toEqual "N/A"

    it "should allow a string as unit factor input", ->
      expect( ViewHelper.pluralize("2", "hour")).toEqual "2 hours"
