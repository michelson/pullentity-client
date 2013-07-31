class Pullentity.Models.Site extends Backbone.Model
  url : ()->
    if @id
      "#{Pullentity.Domain}.pullentity.com/api/v1/site"
    else
      "#{Pullentity.Domain}.pullentity.com/api/v1/sites"

