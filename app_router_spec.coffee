describe "AppRouter", ->
  describe "running the application", ->
    describe "with views that need a ServiceRequest", ->
      FooView = Backbone.View.extend
        model:ServiceRequest
        bootstraps:
          needs_service_request: true
        initialize: (opts)->
          @model = opts.service_request

      beforeEach ->
        ServerMocker.mock_model(ServiceRequest, "abc123", Fixtures.service_request)
        app = new AppRouter
        runs ->
          app.prep_and_run(FooView, "abc123")
        waits 1

      it "should bootstrap the DOM with the appropriate view", ->
        runs ->
          expect(Bootstrapper.current instanceof FooView).toBeTruthy()

      it "should set the View with the correct ServiceRequest object", ->
          expect(Bootstrapper.current.model.id).toEqual "abc123"

      describe "and a project", ->
        BarView = Backbone.View.extend
          model:ServiceRequest
          bootstraps:
            needs_service_request: true
            needs_project: true
          initialize: (opts)->
            @model = opts.service_request
            @model.project = opts.project

        project_id = 'abbabfebb133'
        beforeEach ->
          sr = new ServiceRequest({id: "abc123", project_id: project_id})
          ServerMocker.mock_model(ServiceRequest, "abc123", sr)
          ServerMocker.mock_model(Project, project_id, new Project({id: project_id}))
          runs ->
            app.prep_and_run(BarView, "abc123")
          waitsFor(->!!(Bootstrapper.current.model.project))

        it "should fetch the associated project", ->
          expect(Bootstrapper.current instanceof BarView).toBeTruthy()
            
        it "should get the right project", ->
          runs ->
            expect(Bootstrapper.current.model.project.get('id')).toEqual project_id
