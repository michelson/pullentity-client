class Pullentity.Models.Project extends Backbone.Model

class Pullentity.Collections.Projects extends Backbone.Collection

  model: Pullentity.Models.Project

  url : ()->
    if @id
      "#{Pullentity.Domain}.#{Pullentity.host}/api/v1/site/projects/#{@id}"
    else
      "#{Pullentity.Domain}.#{Pullentity.host}/api/v1/site/projects"
