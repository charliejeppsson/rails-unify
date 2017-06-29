/*
 * End users insert this thru universe.com/embed.js
 * Injects listing-iframe-bootstrapper.js and styles.css into the DOM
 */
(function(d, t) {
    t = d.createElement('script');
    t.setAttribute('src', 'https://embed.universe.com/assets/listing-iframe-bootstrapper-2.15.0-293-g2b1fed9.js');
    t.setAttribute('type', 'text/javascript');
    t.setAttribute('charset', 'UTF-8');
    (document.head || d.getElementsByTagName('head')[0]).appendChild(t);

    t = d.createElement('script');
    t.setAttribute('src', 'https://www.universe.com/embed2.js');
    t.setAttribute('type', 'text/javascript');
    t.setAttribute('charset', 'UTF-8');
    (document.head || d.getElementsByTagName('head')[0]).appendChild(t);

    t = d.createElement('link');
    t.setAttribute('href', 'https://embed.universe.com/assets/unii-styles-2.15.0-293-g2b1fed9.css');
    t.setAttribute('type', 'text/css');
    t.setAttribute('rel', 'stylesheet');
    (document.head || d.getElementsByTagName('head')[0]).appendChild(t);
})(document);
