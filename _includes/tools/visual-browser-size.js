<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script>
// Visual Browser Size @ http://xycss.com/xy/tools/visual-browser-size/
function xycss_dynamic_browser_size(){
	$('#browser-size').text('w : ' + $(window).width() + ' , h : ' + $(window).height()).css({
		width:'120px', bottom:'0', left:'0', background:'#000', cursor:'pointer', padding:'0.75em', 
		zIndex:9999, position:'fixed', textDecoration:'none', color:'#fff', opacity:0.7
	}).hover(function(){
		$(this).css({ opacity:0.9 });
	},function(){
		$(this).css({ opacity:0.7 });
	});
}
$(document).ready(function(){
	if($(window).width() > 480) {
		$('body').append('<div class="button" id="browser-size"></div>');
	}
	xycss_dynamic_browser_size();
});
$(window).resize(function() {
	xycss_dynamic_browser_size();
});
</script>