Handlebars.registerHelper 'SectionUrl', (section)->
  "#sections/#{section.id}"

Handlebars.registerHelper 'ProjectUrl', (project)->
  "#projects/#{project.id}"

Handlebars.registerHelper 'ProjectImg', (version)->
  v = version ? version : "url"
  @photos[0].image.image[v]

Handlebars.registerHelper 'PhotoImg', (version)->
  @image.image[version].url
