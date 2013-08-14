class Pullentity.Views.Commons.Main extends Backbone.View
  el: "body"

  events:
    "click": "hideSuggests"

  initialize: ->

    #console.info "pullentity LOADED!!!"
    @site = new Pullentity.Models.Site(id: "michelsongs")
    @site.on("change", @initModels )
    @site.fetch()

  initModels: ()=>
    #console.log("init models")
    @sections = new Pullentity.Collections.Sections(@site.get('sections'))
    @projects = new Pullentity.Collections.Projects(@site.get('projects'))
    #debugger
    #console.log("Site Loaded!")
    #console.log @sections
    #console.log @projects
    @setTitle()

    @render()

    @setupLinks()

    # quizas cargar router acá

  setTitle: ()=>
    #console.log @site.get("name")
    document.title = "#{@site.get("name")} pullentity site"

  initRouter: ()=>
    @app_router = new Pullentity.Routers.main

    @app_router.on 'route:defaultRoute', (actions)=>
      #console.log(actions) # See more at: http://backbonetutorials.com/what-is-a-router
      #console.log("init routes")
      @render_home_project()

    @app_router.on 'route:getProject', (id)=>
      #console.log("get project #{id}")
      @find_project_by_id(id)

    @app_router.on 'route:getSection', (id)=>
      #console.log("get section #{id}")
      @find_in_section(id)

    Backbone.history.start(pushState: true)

  render: ()=>
    #console.info("should render layout")
    source   = $("#layout").html()
    @theme_templates = $(".pullentity-themes")
    @layout = Handlebars.compile(source)
    #console.log(@site.attributes)
    $("body").html(@layout(@site.attributes))
    @initRouter()

  render_home_project: ()=>
    @current_project = @projects.findWhere({home: true })
    @find_theme_for_project()
    @render_project()

  find_project_by_id: (id)=>
    @current_project = @projects.findWhere({id: parseInt(id) })
    @find_theme_for_project()
    @render_project()

  find_in_section: (id)=>
    @current_section = @sections.findWhere({ id: parseInt(id) })
    @render_project_or_list(id)

  render_project_or_list: (id)=>
    switch @current_section.get("list_or_project")
      when "project" then @render_project_theme()
      when "list"    then @render_list()

  render_project_theme: ()=>
    @current_project = @projects.findWhere(section_id: @current_section.id )
    @find_theme_for_project()
    @render_project()

  render_list: ()=>

    #si tiene theme para la lista
    if @theme_list = @current_section.get("theme_template")
      @current_theme_obj = @find_theme_for_list()
    else
      @current_theme_obj = _.find @theme_templates, (num)=>
        if $(num).attr("id") == "list"
          num

    @find_projects_for_list(@current_section)
    @render_handlebars()
    $("#content").html(@current_template({section: @current_section.attributes, projects: @list_projects }))

  render_project: ()=>
    @render_handlebars()
    $("#content").html(@current_template(@current_project.attributes))

  find_theme_for_project: ()=>
    @current_theme_obj = _.find @theme_templates, (num)=>
      if $(num).attr("id") == @current_project.get("theme_template").name
        num
    console.error "theme \"#{@current_project.get("theme_template").name}\" does not exist" unless @current_theme_obj

  find_theme_for_list: ()=>
    #console.log("list with theme!")
    name = @current_section.get("theme_template").name
    theme = _.find @theme_templates, (num)=>
      if $(num).attr("id") == name
        num
    theme ? theme : @render_with_error(name)

  find_projects_for_list: (section)=>
    @list_projects = _.filter @projects.toJSON(), (num)=>
      if num.section.public_url == section.get("public_url")
        num

  render_with_error: (name)=>
    $("#content").html("<pre>Couldn´t find template #{name} in /source/views/themes</pre>")
    console.warn "Couldn´t find projects in #{name} yet"

  render_handlebars: ()=>
    try
      @current_template = Handlebars.compile($(@current_theme_obj).html())
    catch e
      #console.error "error while creating Handlebars script out of template for [", $(@current_theme_obj), e
      throw e

  setupLinks: ()=>
    # Globally capture clicks. If they are internal and not in the pass
    # through list, route them through Backbone's navigate method.
    $(document).on "click", "a[href^='/']", (event) =>

      href = $(event.currentTarget).attr('href')

      # chain 'or's for other black list routes
      passThrough = href.indexOf('sign_out') >= 0

      # Allow shift+click for new tabs, etc.
      if !passThrough && !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey
        event.preventDefault()

        # Remove leading slashes and hash bangs (backward compatablility)
        url = href.replace(/^\//,'').replace('\#\/','')

        # Instruct Backbone to trigger routing events
        @app_router.navigate url, { trigger: true }

        return false

layout = new Pullentity.Views.Commons.Main
