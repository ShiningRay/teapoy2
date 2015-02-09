 var waitingforinput="";
 var editorTextPosition = -1;
    var editorPositionFunc = function() {
      editorTextPosition = $(this).textPosition();
    };


$("#faceTitle").click(function(event){
    var T,L;
    var facetitle  = $(this);
    waitingforinput = facetitle.parents(".inputs:first").find("textarea");

    waitingforinput.mouseup(editorPositionFunc).keyup(editorPositionFunc);
     var Pos = function(){
      $("#faceContent").css("top", parseInt(waitingforinput.offset().top) + "px");
      $("#faceContent").css("left", parseInt(facetitle.offset().left) + "px");
      $("#faceContent").show();
  }
    Pos();
  event.stopPropagation();
  $("html").click(function(){
    $("#faceContent").hide();
  });

    //窗口改变时自动调整位置
    $(window).resize(function(){
      Pos();
    });

});

$("#faceContent").on("click", 'span', function(){
    if (editorTextPosition == -1) {
        editorTextPosition = waitingforinput.textPosition();
       }
    waitingforinput.textPosition(editorTextPosition, ":"+$(this).attr("class").split(" ")[1]+":");
  });
