#= require_self
#= require_tree ./helpers
#= require_tree ../templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Pullentity =
  Domain: pullentity_domain
  Models: {}
  Collections: {}
  Routers: {}
  Views: {
    Commons: {}
  }

  Helpers:
    BootstrapHelpers: {}

#if !Backbone.history.started
#  Backbone.history.start()
#  Backbone.history.started = true







