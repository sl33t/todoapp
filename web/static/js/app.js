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

$(document).on("mouseout", "#google_button",
  function(event){
    document.getElementById("google_button").src = "/images/google/google_btn.png";
  }
);

$(document).on("mouseover", "#google_button",
  function(event){
    document.getElementById("google_button").src = "/images/google/google_btn_focus.png";
  }
);

$(document).on("mousedown", "#google_button",
  function(event){
    document.getElementById("google_button").src = "/images/google/google_btn_pressed.png";
  }
);

function googleOnPress(){
  $("#google_button").src = "/images/google/google_btn_focus.png";
}

function flash_messages(type, message){
  if ($(".alert")[0]){
    var alert = $(".alert");
    alert.attr('class',
           function(i, c){
              return c.replace(/(^|\s)alert-\S+/g, ' alert-' + type);
           });
    alert.text(message);
  }
  else {
     var paragraph = $("<p>", {class: "alert alert-" + type, text: message});
     $("header").append(paragraph);
  }
}

$(document).on("submit", ".new_todo_form",
  function(event){
    event.preventDefault();
    $.ajax({
        url: "/api/create",
        type: "post",
        data: {
          todolistitem: { text: $(".create_input").val() }
        },
        headers: {
            "X-CSRF-TOKEN": csrf
        },
        dataType: "json"
    }).done(
      function(data){
        if (data.state){
          $(".create_input").val("");
          var div = $("<div>", {class: "col-xs-12 input-group"});
          div.append(
            $("<p>", {class: "todo_item", id: data.id, text: data.text})
          );
          var span = $("<span>", {class: "input-group-btn" + data.id});
          var button = $("<button>", {text: "Remove", type: "button", class: "btn btn-danger remove_button remove_button" + data.id});
          span.append(button);
          div.append(span);
          $(".todo_items").append(div);
        }
        flash_messages(data.flash_type, data.flash_message);
      }
    );
  }
);

$(document).on("click", ".remove_button",
  function(){
    var button = this;
    $.ajax({
        url: "/api/delete/" + $(this).parent("span").prev("p").attr("id"),
        type: "delete",
        headers: {
            "X-CSRF-TOKEN": csrf
        },
        dataType: "json"
    }).done(
      function(data){
        if(data.state){
          $(button).parent("span").parent("div").remove();
        }
        flash_messages(data.flash_type, data.flash_message);
      }
    );
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
        url: "/api/edit/" + this.id,
        type: "put",
        data: {
          todolistitem: { text: $(this).val() }
        },
        headers: {
            "X-CSRF-TOKEN": csrf
        },
        dataType: "json"
    }).done(
      function(data){

        flash_messages(data.flash_type, data.flash_message);
      }
    );
  }
);

$("#main_list").sortable({
    update: function(event, ui) {
      var data = $(this).sortable('serialize', {key: "todoitem"});

      alert(data);
      // POST to server using $.post or $.ajax
      $.ajax({
          type: 'POST',
          url: '/api/reorder',
          data: {
            serializedListOfTodoItems: data
          },
          headers: {
              "X-CSRF-TOKEN": csrf
          },
          dataType: "json"
      }).done(
        function(data){

          flash_messages(data.flash_type, data.flash_message);
        }
      );
    }
})
