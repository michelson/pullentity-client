Handlebars.registerHelper 'SectionUrl', (section)->
  "/#sections/#{section.id}"

Handlebars.registerHelper 'ProjectUrl', (project)->
  "/#projects/#{project.id}"

Handlebars.registerHelper 'ProjectImg', (version)->
  v = version ? version : "url"
  return if _.isEmpty(@photos[0])
  @photos[0].image.image[v].url

Handlebars.registerHelper 'PhotoImg', (version)->
  @image.image[version].url
