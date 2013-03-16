//= require "mustache"

$(document).ready(function() {

  var template, html;

  window.data = {
      site_link: "/",
      site: {
        name: "MySite",
      },
      sections: [
        { public_url: "#home", title: "photos", show_in_menu: true },
        { public_url: "#list", title: "books", show_in_menu: true },
        { public_url: "#theme1", title: "theme1", show_in_menu: true }
      ],
      project: {
        title: "My Awesome Project",
        body: "lorem bla bla"
      },
      photos: [
        {   title: "my favorite things",
            caption: "donuts, pizza, computers",
            img_large: "http://farm7.staticflickr.com/6161/6187349656_4be054c2d8_z_d.jpg"
        },
        {
          title: "mexican",
          caption: "Mexican letters",
          img_large: "http://www.fontplay.com/freephotos/fourteen/fp112308-28.jpg"
        },
        {
          title: "Rome",
          caption: "When in Rome",
          img_large: "http://www.fontplay.com/freephotos/seventeen/fpx022010-01.jpg"
        },
        {
          title: "Salvo",
          caption: "Salvo",
          img_large: "http://www.fontplay.com/freephotos/fourteen/fp110608-21.jpg"
        }

      ],
      section: {
        title: "some section here"
      },
      projects: [
        {
          project_photo: "http://farm7.staticflickr.com/6161/6187349656_4be054c2d8_z_d.jpg",
          title: "project title",
          project_path: "#home"
        },
        {
          project_photo: "http://farm7.staticflickr.com/6161/6187349656_4be054c2d8_z_d.jpg",
          title: "project title 2",
          project_path: "#home"
        },
        {
          project_photo: "http://farm7.staticflickr.com/6161/6187349656_4be054c2d8_z_d.jpg",
          title: "project title 3",
          project_path: "#home"
        }
      ],
      public_url: "http://artenlinea.com",
      url : function () {
          return function (text, render) {
              text = render(text);
              var url = text.trim().toLowerCase().split('tuts+')[0] + '.tutsplus.com';
              return '<a href="' + url + '">' + text + '</a>';
          }
      }
  };

  // layout
  template = $("#layout").html();
  layout = Mustache.to_html(template, data);
  $("body").html(layout);


  $(window).on('hashchange', function(e) {
    theme = $("#yield-scripts " + window.location.hash + " ").html();
    console.log( theme );
    view = Mustache.to_html(theme, window.data);
    $("#loadScripts").html(view);
  });


});