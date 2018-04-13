// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.

//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery.mark.min.js
//= require_tree .


$(document).on('turbolinks:load', function() {
  // add eventListeners for all email thumbs on the list to change highlight and list scroll
  for (var i = 1, n = $(".email-thumb-container");i <= n.length; i++) {
    (function(n,i){
      var target = n[i - 1];
      target.addEventListener("click", function(){
        changeActiveEmailThumb(i, false);
      }, false);
      if ( $(target).hasClass("email-thumb-active") ) { changeActiveEmailThumb(i, true); }
    })(n,i);
  }

  // add eventListeners for email navigation with chevrons
  $('body').on("click", "#prevEmail", prevEmail);
  $("body").on("click", "#nextEmail", nextEmail);

  // add eventListeners for marking the searched text in the email
  $(document).on("input", "#search_email_message", markEmail);
  $(document).on("input", "#search_contacts", markContact);

  $('.alert').fadeOut(10000);
  $('.alert-close').on('click', function(){
    $('.alert').hide();
  });

});




function changeActiveEmailThumb(id, scroll) {
  // remove previously active email and highlight the new one
  $(".email-thumb-active").removeClass("email-thumb-active");
  $("#emailThumb" + id).addClass("email-thumb-active");

  // scroll the emails list to accomodate for the selected email
  if (scroll === true) {
    scrollDiv = document.getElementById("emailListScroll");
    scrollTarget = document.getElementById("emailThumb" + id);
    if ($("#emailThumb" + id).position().top > ( window.innerHeight - scrollTarget.offsetHeight)) {
      scrollDiv.scrollTop = scrollTarget.offsetTop - window.innerHeight + scrollTarget.offsetHeight;
    }else if ( $("#emailThumb" + id).position().top < 51 ) {
      scrollDiv.scrollTop = scrollTarget.offsetTop - 51;
    }
  } 
}

function prevEmail() {
  var active = $(".email-thumb-active")[0]; // get active thumb
  var current_id = parseInt(active.id.substr(10)); // get id number of active thumb

  // change active thumb if the previous one exists
  if (current_id > 1) {
    $("#emailThumb" + (current_id - 1)).trigger("click");
    changeActiveEmailThumb(current_id - 1, true);
  }
}

function nextEmail() {
  var active = $(".email-thumb-active")[0]; // get active thumb
  var current_id = parseInt(active.id.substr(10)); // get id number of active thumb

  // change active thumb if the next one exists
  if (current_id < $(".email-thumb-container").length) {
    $("#emailThumb" + (current_id + 1)).trigger("click");
    changeActiveEmailThumb(current_id + 1, true);
  }
}

function markEmail() {
  var search = $("#search_email_message").val(); // get the searched text

  // unmark the previous search and mark the current one
  $("#email_message").unmark({
    done: function() {
      $("#email_message").mark(search, {className: 'marking', separateWordSearch: false});
      if ( $(".marking").length ) {
        document.getElementsByClassName("marking")[0].scrollIntoView(true);
      }
    }
  });
};

function markContact() {
  var search = $("#search_contacts").val(); // get the searched text

  // unmark the previous search and mark the current one
  $(".contacts-col-name").unmark({
    done: function() {
      $(".contacts-col-name").mark(search, {className: 'marking', separateWordSearch: false});
      if ( $(".marking").length ) {
        document.getElementsByClassName("marking")[0].scrollIntoView(true);
      }
    }
  });
};