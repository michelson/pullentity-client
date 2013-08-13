#= require_self
#= require_tree ./helpers
# require_tree ../templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

unless window.console
  console =
    log: ->
    alert: ->
    info: ->

if _.isUndefined window.pullentity_domain
  alert("Please configure the domain name in pullentity.yml file or run pullentity auth login")
  false

window.Pullentity =
  Domain: window.pullentity_domain
  host:  "pullentity.com" # "pullentity.dev:3000" #
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







