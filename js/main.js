$(function() {
    var PHPHub = {
        init: function() {
            this.bind();
        },

        bind: function() {
            var self = this;
            var wow = new WOW(
              {
                boxClass:     'wow',
                animateClass: 'animated',
                offset:       300, 
                mobile:       true,
                live:         true,
                callback:     function(box) {
                  // the callback is fired every time an animation is started
                  // the argument that is passed in is the DOM node being animated
                },
                scrollContainer: null
              }
            );
            wow.init();
        }
    };

    PHPHub.init();
});