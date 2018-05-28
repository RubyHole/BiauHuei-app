// round.slim
$(document).ready(function() {
    $(".dropdown-item").click(function() {
        selfRoundId = $(this).attr("self-round-id");
        targetRoundID = $(this).attr("target-round-id");
        $("#round_" + selfRoundId).removeClass("d-block").addClass("d-none");
        $("#round_" + targetRoundID).addClass("d-block").removeClass("d-none");
    });
}); 

// new_group.slim
$(document).ready(function() {
    $(".add-more").click(function(){
        var text = $(this).parents(".control-group").children("input").val();
        $(this).parents(".control-group").children("input").val('');
        
        var $html = $($(".copy-fields").html());
        $html.children("input").val(text);
        
        $(".after-add-more").before($html);
        
        //$(".validate-add-more").removeClass("invisible");
    });
    
    $(".active-input").on("focus", function() {
        $(".validate-add-more").addClass("invisible");
    });
    
    $("body").on("click",".remove",function(){ 
        $(this).parents(".control-group").remove();
    });
});
