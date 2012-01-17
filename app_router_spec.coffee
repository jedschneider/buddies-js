describe "AppRouter", ->
  describe "running the application", ->
    describe "with views that need a ServiceRequest", ->
      FooView = Backbone.View.extend
        bootstraps:
          needs_service_request: true
        initialize: (opts)->
          @model = opts.service_request

      beforeEach ->
        SpecHelper.mock_catalog()
        SpecHelper.mock_service_request(Fixtures.service_request)
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
          sr = Factory.service_request(Fixtures.catalog, {project_id: project.id})
          project_id = project.id
          SpecHelper.mock_service_request sr
          ServerMocker.mock_model(Project, project_id, project)
          runs ->
            app.view.bootstrap(BarView, sr.id)
          waitsFor(->!!(app.view.current.model?.project))

        it "should fetch the associated project", ->
          expect(app.view.current instanceof BarView).toBeTruthy()

        it "should get the right project", ->
          runs ->
            expect(app.view.current.model.project.get('id')).toEqual project_id
