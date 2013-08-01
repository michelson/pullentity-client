class Pullentity.Models.Section extends Backbone.Model


class Pullentity.Collections.Sections extends Backbone.Collection

  model: Pullentity.Models.Section

  url : ()->
    if @id
      "#{Pullentity.Domain}.#{Pullentity.host}/api/v1/site/sections/#{@id}"
    else
      "#{Pullentity.Domain}.#{Pullentity.host}/api/v1/site/sections"

