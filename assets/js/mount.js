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
    function isExistedUsername(text) {
        $.ajax({
            type: "GET",
            url: '/account/existed/' + text,
            data: {},
            dataType: 'json',
            xhrFields: {
               withCredentials: true
            },
            crossDomain: true,
            success: function (data, textStatus, xmLHttpRequest) {
                console.log(data);
                return data;
            },
            error: function (xhr, ajaxOptions, thrownError) {
                console.log('error')
                //toastr.error('Somthing is wrong', 'Error');
            },
        });
        //$.get('/account/existed/' + text, function(data) {
        //    response_body = data;
        //});
        return response_body;
    }
    
    $(".add-more").click(function(){
        $add_more = $(this);
        var text = $add_more.parents(".control-group").children("input").val();
        
        $.ajax({
            type: "GET",
            url: '/account/existed/' + text,
            data: {},
            dataType: 'json',
            xhrFields: {
               withCredentials: true
            },
            crossDomain: true,
            success: function (data, textStatus, xmLHttpRequest) {
                if (data['is_existed'] == true) {
                    append_new_member($add_more);
                }
                else {
                    show_member_not_found_error();
                }
                //console.log(data['is_existed']);
            },
            error: function (xhr, ajaxOptions, thrownError) {
                show_member_not_found_error();
                //console.log('error')
            },
        });
    });
    
    function append_new_member($add_more, text) {
        var text = $add_more.parents(".control-group").children("input").val();
        $add_more.parents(".control-group").children("input").val('');
        
        var $html = $($(".copy-fields").html());
        $html.children("input").val(text);
        
        $(".after-add-more").before($html);
    }
    
    function show_member_not_found_error() {
        $(".validate-add-more").removeClass("invisible");
    }
    
    $(".active-input").on("focus", function() {
        $(".validate-add-more").addClass("invisible");
    });
    
    $("body").on("click",".remove",function(){ 
        $(this).parents(".control-group").remove();
    });
});

// bootstrap-confirmation
$('[data-toggle=confirmation]').confirmation({
  rootSelector: '[data-toggle=confirmation]',
  // other options
});
