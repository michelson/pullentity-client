class Pullentity.Models.Project extends Backbone.Model

class Pullentity.Collections.Projects extends Backbone.Collection

  model: Pullentity.Models.Project

  url : ()->
    if @id
      "#{Pullentity.Domain}.pullentity.com/api/v1/site/projects/#{@id}"
    else
      "#{Pullentity.Domain}.pullentity.com/api/v1/site/projects"
