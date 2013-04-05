# Don't edit this file unless you know you are doing
# this file is for local testing only and will not be uploaded within theme to pullentity.com
#= require "underscore-min"
#= require "mustache"

$(document).ready ->
  template = undefined
  html = undefined
  window.base_image_path = ""
  window.theme = ""
  window.list_theme = ""
  window.mustache_themes = ""
  window.data = {}
  window.data =
    site_link: "/"
    public_url: "http://pullentity.com"
    project: {}
    photos: []
    current_section: ""
    url: ->
      (text, render) ->
        text = render(text)
        url = text.trim().toLowerCase().split("tuts+")[0] + ".tutsplus.com"
        "<a href=\"" + url + "\">" + text + "</a>"

  $.getJSON( "/assets/javascripts/pullentity_data.json", (json_data) ->
    ).success((json_data)->
      items = []
      #debugger
      window.data["site"] =
        name: json_data.name
        subdomain: json_data.subdomain

      window.data["sections"] = []

      $.each json_data.sections, (key, val) ->
        window.data["sections"].push val

      window.data["projects"] = []
      $.each json_data.projects, (key, val) ->
        window.data["projects"].push  val

      window.init_themes()
    )
    .error(->
      html = "<div style='margin:20px'><h1>data file not found<h1>"
      html += "<pre>please run 'pullentity setup' in console to setup autentication and import data</pre>"
      html += "<pre>or 'pullentity theme import_data' in console, if you already have authenticated your theme</pre></div>"
      $("body").html(html)
    )

  # layout initialization
  window.init_themes = ()->

    window.theme = ""

    window.data["project"] = {}

    template = $("#layout").html()

    window.mustache_themes = $(".pullentity-themes")

    window.list_theme =  $(".pullentity-themes#list")

    layout = Mustache.to_html(template, data)

    $("body").html layout

    simple_router(window.location.hash)

    $(window).on "hashchange", (e) ->
      simple_router(window.location.hash)

  window.simple_router = (url)->
    # find section by window.location, then find project and theme
    url = window.location.hash
    #console.log "changed to #{url}"
    m = switch
      when url == "" then render_home_project()
      when /(\w)\/\d/.test(url) then find_project_by_id()
      when /(\w)/.test(url) then find_in_section()
      else
        console.warn("not matching url")

  window.render_theme = (theme_html, data_hsh = window.data)->
    if theme_html?
      view = Mustache.to_html(theme_html, data_hsh)
      $("#content").html view
    else
      html = "<div style='margin:20px'><h1>Theme \"#{window.data.project.theme_template.name}\" not found!<h1>"
      html += "<pre>Please create it in /source/views/themes/#{window.data.project.theme_template.name}.haml</pre></div>"
      $("body").html(html)

  window.render_list_theme = (theme_html, data_hsh = window.data)->
    if theme_html?
      view = Mustache.to_html(theme_html, data_hsh)
      $("#content").html view
    else
      html = "<div style='margin:20px'><h1>Theme \"#{window.data.current_section.theme_template.name}\" not found!<h1>"
      html += "<pre>Please create it in /source/views/themes/#{window.data.current_section.theme_template.name}.haml</pre></div>"
      $("body").html(html)


  # get home project and render it
  window.render_home_project = ()->

    window.data["project"] = _.find(window.data.projects, (p) ->
      p.home
    )

    fill_projects(window.data["project"].photos)

    find_theme_for_project()

    render_theme($(window.theme[0]).html())

  # points path for remote image resources
  window.remote_path = (path)->
    "#{path}"


  # builds the project photos hsh
  window.fill_projects = (collection)->
    window.data["photos"] = []
    $.each collection, (key, val) ->
      window.data["photos"].push
       img_medium: remote_path( val.image.image.medium.url)
       img_large: remote_path(val.image.image.xlarge.url)
       img_thumb: remote_path(val.image.image.thumb.url)
       title: val.title
       caption: val.caption


  # display project or list
  window.display_project_or_list = (_tis)->

    if _tis.list_or_project == "project"

      #console.log("trying theme #{window.data["project"].theme_template.name}")

      find_theme_for_project()

      fill_projects(window.data["project"].photos)

      render_theme($(window.theme[0]).html())

    else
      #console.log "should be list!!"
      data_projects = data_projects_for_list()

      if data_projects.section.theme_template?
        #debugger
        #theme = data_projects.section.theme_template.name
        find_theme_for_list()
        render_list_theme($(window.theme[0]).html(), data_projects)
      else
        render_theme($(window.list_theme).html(), data_projects)

    false


  # finds the theme for project
  window.find_theme_for_project = ()->
    window.theme = $($(_.find($(window.mustache_themes), (num) ->
        $(num).attr("id") == window.data["project"].theme_template.name
      )).html())

  # finds the theme for list
  window.find_theme_for_list = ()->
    window.theme = $($(_.find($(window.mustache_themes), (num) ->
        $(num).attr("id") == window.data["current_section"].theme_template.name
      )).html())

  # find data for project list
  window.data_projects_for_list = ()->
    section = _.find( window.data["sections"] , (num) ->
      num.public_url == window.location.hash
    )
    window.data.current_section = section

    a = _.filter(window.data["projects"], (num) ->
      true  if num.section.public_url is section.public_url
    )

    project_collection = _.map a, (p)->
      p["project_photo"] = remote_path(p.photos[0].image.image.medium.url) unless p.photos.length == 0
      p

    {section: section, projects: project_collection }

  # maps project for section
  window.find_in_section = ()->

    $.each window.data.sections, ()->

      if this.public_url == window.location.hash
        _tis = this
        _tis.finds = false

        window.data["project"] = _.find( window.data.projects , (p)->
          p.section.public_url == _tis.public_url
        )

        if window.data["project"]?
          display_project_or_list(_tis)
        else
          $("#content").html("<pre>Couldn´t find projects in #{_tis.public_url} yet</pre>")
          console.warn "Couldn´t find projects in #{_tis.public_url} yet"

  # find by id
  window.find_project_by_id = ()->

    window.data["project"] = _.where(window.data.projects, { project_path: window.location.hash })[0]

    find_theme_for_project()
    fill_projects(window.data["project"].photos)
    render_theme($(window.theme[0]).html())