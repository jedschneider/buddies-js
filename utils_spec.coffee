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

  describe "date", ->
    it "should format appropriately", ->
      expect(ViewHelper.date("2011-08-31 16:45:30 UTC")).toEqual "11/08/31"

    it "should return a blank string if no string is given", ->
      expect(ViewHelper.date(null)).toEqual ""
