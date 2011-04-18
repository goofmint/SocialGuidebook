;(function($){
    $.fn.superselect=function(options){
        var settings = $.extend($.fn.superselect.defaults, options||{ });
		return this.each(function(i){
            var theSelect = $(this);
            theSelect.hide();
            var newid = "superselect-"+$.fn.superselect.count;
            theSelect.attr('superselect',newid);
            $.fn.superselect.count++;
            theSelect.after('<div id="'+newid+'" style="display:inline-block" class="superselect-container"><div class="superselect-title" /></div>');
            $('body').append('<div id="'+newid+'-options" "class="superselect-selectionbox" style="position:absolute;"><div class="superselect-options"></div></div>');
            $('#'+newid+'-options').css({opacity:settings.opacity}).hide();
            theSelect.bind('change',function(){
                setTimeout(function(){
                    $.fn.superselect.originalChange( theSelect, newid );
                },50);
            });
            theSelect.find('option').each( function(){
                theOption = $(this);
                var tmpHtml = '';
                var theValue = theOption.val();
                var rel = theOption.attr('rel');
                if(rel && (m = rel.match(/icon\[([^\]]+)\]/) ) != null ){
                    //an icon first.
                    tmpHtml+= '<img src="'+m[1]+'" class="superselect-icon" /> ';
                }
                tmpHtml += theOption.html();
                if(!theOption.attr('value') || theOption.attr('value') == '' ){
                    //this is the title block
                    $('#'+newid+' .superselect-title').attr('rel',tmpHtml ).html( tmpHtml );
                    $('#'+newid).click(function(){
                        $.fn.superselect.toggle( newid, settings.speed );
                    });
                }else{
                    // a new option!
                    $('#'+newid+'-options .superselect-options').append('<div class="superselect-option" rel="'+theValue+'">'+tmpHtml+'</div>');
                    $('#'+newid+'-options .superselect-option:last')
                        .click(function(){
                            $.fn.superselect.close( newid, settings.speed );
                            theSelect.val(theValue);
                            theSelect.trigger('change');
                        });
                }
            });
        });
    };
    $.fn.superselect.count = 0;
    //Default Options
	$.fn.superselect.defaults = { 
        speed : 'fast',
        opacity : 1
    };
    $.fn.superselect.originalChange=function( sel, id ){
        //the original selectbox changed, so we should to the same.
        var value = $(sel).val();
        if(value == ''){
            $.fn.superselect.internalReset( id );
        }else{
            //show current item.
            $('#'+id+' .superselect-title').html( $('#'+id+'-options div[rel="'+value+'"]').html() );
        }
    };
    $.fn.superselect.reset=function( domid ){
        //domid is original select, with id of new in attribute "superselect"
        //clear value and trigger change
        $('#'+domid).val('').trigger('change');
    };
    $.fn.superselect.internalReset=function( id ){
        $('#'+id+' .superselect-title').html( $('#'+id+' .superselect-title').attr('rel') );
    };
    $.fn.superselect.open=function( id, speed ){
        var dropdown = $('#'+id+'-options');
        var pos = $('#'+id).offset();
        var height = $('#'+id).height();
        dropdown.css({left:pos.left, top: pos.top+height+2});
        $('#'+id+' .superselect-title').addClass('open');
        dropdown.slideDown(speed, function(){
            $('body').click( $.fn.superselect.catchme );
        });
    };
    $.fn.superselect.close=function( id, speed ){
        $('body').unbind( 'click', $.fn.superselect.catchme );
        $('#'+id+' .superselect-title').removeClass('open');
        $('#'+id+'-options').slideUp(speed);
    };
    $.fn.superselect.toggle=function( id, speed ){
        if( $('#'+id+'-options').is(':hidden') ){
            $.fn.superselect.open(id, speed);
        }else{
            $.fn.superselect.close(id, speed);
        }        
    };
    $.fn.superselect.catchme=function(){
        $('.superselect-container').each(function(){
            $.fn.superselect.close( $(this).attr('id'), $.fn.superselect.defaults.speed );
        });
    }
})(jQuery);