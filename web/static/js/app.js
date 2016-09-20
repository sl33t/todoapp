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
  }
);
