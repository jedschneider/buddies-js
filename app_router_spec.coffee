describe "AppRouter", ->
  describe "running the application", ->
    describe "with views that need a ServiceRequest", ->
      catalog = null
      FooView = Backbone.View.extend
        bootstraps:
          needs_service_request: true
        initialize: (opts)->
          @model = opts.service_request

      beforeEach ->
        {catalog} = SpecHelper.mock_catalog_and_service_request('abc123')
        runs ->
          app.view.bootstrap(FooView, "abc123")
        waits 500

      it "should bootstrap the DOM with the appropriate view", ->
        runs ->
          expect(app.view.current instanceof FooView).toBeTruthy()

      it "should set the View with the correct ServiceRequest object", ->
          expect(app.view.current.model.id).toEqual "abc123"

      describe "and a project", ->
        BarView = Backbone.View.extend
          model:ServiceRequest
          bootstraps:
            needs_service_request: true
            needs_project: true
          initialize: (opts)->
            @model = opts.service_request
            @model.project = opts.project

        project_id = null
        beforeEach ->
          project = Factory.project()
          sr = Factory.service_request(catalog, {project_id: project.id})
          project_id = project.id
          SpecHelper.mock_service_request sr, catalog
          ServerMocker.mock_model(Project, project)
          runs ->
            app.view.bootstrap(BarView, sr.id)
          waitsFor(->!!(app.view.current.model?.project))

        it "should fetch the associated project", ->
          expect(app.view.current instanceof BarView).toBeTruthy()

        it "should get the right project", ->
          runs ->
            expect(app.view.current.model.project.get('id')).toEqual project_id

  describe "Adding new services", ->
    spy = null
    beforeEach ->
      spy = ServerMocker.accept_create ServiceRequest, 'abc346'
      SpecHelper.mock_current_user()
      SpecHelper.mock_catalog()
      ServerMocker.mock_model ServiceRequest,
        id: 'abc346'
        project_id: '2985'
        line_items: []
        sub_service_requests: {}
      project = Factory.project(id: "2985")
      ServerMocker.mock_model Project, project
      runs ->
        app.navigate("projects/2985/add_services", true)
      SpecHelper.waitsForView CatalogView

    it "should create a new service request", ->
      expect(spy).toHaveBeenCalled()
      atts = spy.mostRecentCall.args[3]
      expect(atts.project_id).toEqual '2985'

    it "should go to the catalog view for the new service request", ->
      expect(app.view.current.model.id).toEqual 'abc346'