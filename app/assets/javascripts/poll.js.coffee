
formProcess = ->
  f = $(this)
  container = f.parents("#poll-container:first")
  container.fadeOut "slow", ->
    $.ajax
      type: "POST"
      dataType: "json"
      url: f.attr("action")
      data: f.serialize()
      success: (vote) ->
        $.getJSON "/" + vote.group + "/" + vote.article_id, (data) ->
          total_votes = 0
          percent = undefined
          data = data.top_post.results
          for vote in data
            total_votes = total_votes + (vote[OPT_VOTES])
          results_html = "<div id='poll-results'><h3>投票结果</h3>\n<dl class='graph'>\n"
          for vote in data
            percent = Math.round((vote[OPT_VOTES] / total_votes) * 100)
            results_html = results_html + "<dt class='bar-title'>" + vote[OPT_TITLE] + "</dt><dd class='bar-container'><div class='bar  choice_" + vote[OPT_ID] + "'style='width:0%;'>&nbsp;</div><strong>" + percent + "%</strong></dd>\n"
          results_html = results_html + "</dl><p>总投票人数: " + total_votes + "</p></div>\n"
          container.empty().append(results_html).fadeIn "slow", ->
            animateResults container

  false
animateResults = (f) ->
  $("#poll-results div", f).each ->
    percentage = $(this).next().text()
    $(this).css(width: "0%").animate
      width: percentage
    , "slow"
OPT_ID = 0
OPT_TITLE = 1
OPT_VOTES = 2
votedID = undefined
$(document).ready ->
  $("<label for=\"article_top_post_attributes_question_content\">投票选项，每个选项占一行</label>").insertBefore "#article_top_post_attributes_question_content"
  $(".make_vote").submit formProcess