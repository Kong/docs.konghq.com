// EDITABLE CODE CONTENT
$(document).ready(function () {
    $('[contenteditable]').on('paste', function(e) {
        //strips elements added to the editable tag when pasting
        var $self = $(this);
        setTimeout(function() {$self.html($self.text());}, 0);
    }).on('keypress', function(e) {
        if (e.keyCode === 13) {
        // unfocus when hitting enter key
        $('[contenteditable]').blur();
        }
    })
});
