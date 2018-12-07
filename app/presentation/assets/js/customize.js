$(document).ready(function($) {
    $("#search_keyword").click(function() {
        $("#paper_query_input").attr("placeholder", "e.g. 'internet'");
    });

    $("#search_title").click(function() {
        $("#paper_query_input").attr("placeholder", "e.g. 'the internet of things a survey'");
    });
});
