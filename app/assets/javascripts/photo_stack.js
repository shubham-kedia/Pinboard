function photo_stack()
{
$notices = $("#photo_stack li");
$noticeCount = $notices.length;
$curr_index = 0;
$notices.last().addClass('current'); /* Set the image at top of stack to current */

$("#photo_stack")
	.delegate('li', 'click', function() {
		$this = $(this);

		/* If the image is at the top of the stack */
		if ($this.hasClass('current')) {
			/* Work out new z-index value */
			$zi = $this.css('zIndex') - $noticeCount;

			/* Trigger animation */
			$this.addClass('animate');

			/* Assign new z-index value then stop animation after complete */
			setTimeout(function() { $this.css('zIndex', $zi); }, 200);
			setTimeout(function() { $this.removeClass('animate'); }, 1000);

			/* Set next image to current */
			$this.removeClass('current');
			if ($this.index() == 0) {
				$notices.last().addClass('current');
			} else {
				$notices.eq($this.index()-1).addClass('current');
			}
		}
	});
}