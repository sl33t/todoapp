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
    var input = $("<input>", {val: $(this).text(), type: "text", id: this.id, class: "todo_item_input"});
    $(this).replaceWith(input);
    $(".todo_item_btn"+this.id).addClass("todo_item_btn_show");
    input.select();
  }
);

$(document).on("blur", ".todo_item_input",
  function() {
    var paragraph = $("<p>", {id: this.id, class: "todo_item"});
    paragraph.text($(this).val());
    $(this).replaceWith(paragraph);
    $(".todo_item_btn"+this.id).removeClass("todo_item_btn_show");
    paragraph.select();
  }
);
