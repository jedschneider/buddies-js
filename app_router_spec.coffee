describe "AppRouter", ->
  describe "running the application", ->
    describe "with views that need a ServiceRequest", ->
      FooView = Backbone.View.extend
        model:ServiceRequest
        initialize: (atts)->
          @project = atts.project

      beforeEach ->
        ServerMocker.mock_model(ServiceRequest, "abc123", Fixtures.service_request)
        app = new AppRouter
        runs ->
          app.run_with_service_request(FooView, "abc123")
        waits 1

      it "should bootstrap the DOM with the appropriate view", ->
        runs ->
          expect(Bootstrapper.current instanceof FooView).toBeTruthy()

      it "should set the View with the correct ServiceRequest object", ->
          expect(Bootstrapper.current.model.id).toEqual "abc123"

      describe "and a project", ->
        project_id = 'abbabfebb133'
        beforeEach ->
          sr = new ServiceRequest({id: "abc123", project_id: project_id})
          ServerMocker.mock_model(ServiceRequest, "abc123", sr)
          ServerMocker.mock_model(Project, project_id, new Project({id: project_id}))
          runs -> 
            app.run_with_service_request_and_project(FooView, "abc123") 
          waitsFor(->!!(Bootstrapper.current.model.project))

        it "should fetch the associated project", ->
          expect(Bootstrapper.current instanceof FooView).toBeTruthy()
            
        it "should get the right project", ->
          runs ->
            expect(Bootstrapper.current.model.project.get('id')).toEqual project_id