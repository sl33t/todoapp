// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

var csrf = document.querySelector("meta[name=csrf]").content;

$(document).on("click", ".create",
  function(){
    $.ajax({
        url: "/create",
        type: "post",
        data: {
          todolistitem: { text: $(this).parent("span").prev("input").val() }
        },
        headers: {
            "X-CSRF-TOKEN": csrf
        },
        dataType: "json"
    }).done(
      function(todo_item) {
        $(".create_input").val("");
        var div = $("<div>", {class: "col-xs-12 input-group"});
        div.append(
          $("<p>", {class: "todo_item", id: todo_item.id, text: todo_item.text})
        );
        var span = $("<span>", {class: "input-group-btn" + todo_item.id});
        var button = $("<button>", {text: "Remove", type: "button", class: "btn btn-danger remove_button remove_button" + todo_item.id});
        span.append(button);
        div.append(span);
        console.log(button);
        console.log(span);
        $(".todo_items").append(div);
      }
    );
  }
);

$(document).on("click", ".remove_button",
  function(){
    $.ajax({
        url: "/delete/" + $(this).parent("span").prev("p").attr("id"),
        type: "delete",
        headers: {
            "X-CSRF-TOKEN": csrf
        },
        dataType: "json"
    });
    $(this).parent("span").parent("div").remove();
  }
);

$(document).on("click", ".todo_item",

  function() {
    var input = $("<input>", {val: $(this).text(), type: "text", id: this.id, class: "todo_item form-control input-lg"});
    $(this).replaceWith(input);
    $(".remove_button" + this.id).addClass("btn-lg");
    $(".input-group-btn" + this.id).addClass("input-group-btn");
    input.select();
  }
);

$(document).on("blur", ".todo_item",
  function() {
    var paragraph = $("<p>", {id: this.id, class: "todo_item"});
    paragraph.text($(this).val());
    $(this).replaceWith(paragraph);
    $(".remove_button" + this.id).removeClass("btn-lg");
    $(".input-group-btn" + this.id).removeClass("input-group-btn");
    paragraph.select();

    $.ajax({
        url: "/edit/" + this.id,
        type: "put",
        data: {
          todolistitem: { text: $(this).val() }
        },
        headers: {
            "X-CSRF-TOKEN": csrf
        },
        dataType: "json"
    });
  }
);
