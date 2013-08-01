class Pullentity.Models.Site extends Backbone.Model
  url : ()->
    if @id
      "#{Pullentity.Domain}.#{Pullentity.host}/api/v1/site"
    else
      "#{Pullentity.Domain}.#{Pullentity.host}/api/v1/sites"

