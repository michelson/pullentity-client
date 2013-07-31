class Pullentity.Models.Section extends Backbone.Model


class Pullentity.Collections.Sections extends Backbone.Collection

  model: Pullentity.Models.Section

  url : ()->
    if @id
      "#{Pullentity.Domain}.pullentity.com/api/v1/site/sections/#{@id}"
    else
      "#{Pullentity.Domain}.pullentity.com/api/v1/site/sections"

