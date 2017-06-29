/* exported UNII */

/* CustomEvent prototype
 *
 * @returns {undefined}
 */
(function () {
  if (window.CustomEvent) { return; }

  function CustomEvent(event, params) {
    params = params || { bubbles: false, cancelable: false, detail: undefined };
    var evt = document.createEvent('CustomEvent');
    evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
    return evt;
  }

  CustomEvent.prototype = window.Event.prototype;

  window.CustomEvent = CustomEvent;
})();

(function(window, document, undefined) {
  if (window.UNII) {
    return;
  }

  //-----------------------------------------------------------------------------
  // Widget
  //-----------------------------------------------------------------------------

  /* UNII object inserts baseline styles for injected DOM (iframes), assigns a GUID
   * to the object, and provides helper/utility classes for event binding and DOM
   * creation.
   *
   * @returns {object}
   */
  var UNII = {
    create: function (html) {
      var el;
      var div = document.createElement('div');

      div.innerHTML = html;
      el = div.firstChild;

      // XXX This assumes only *one* root element is to be inserted
      document.body.insertBefore(el, null);
      div = null;

      return el;
    },

    createModal: function(options) {
      if (options && options.listing_id) {
        var queryParams = buildQueryParams();
        new UNII.Modal('https://www.universe.com/listings/' + options.listing_id, queryParams).show();
      }
      else {
        throw new Error('Missing parameter: listing_id');
      }
    },

    remove: function (id) {
      var el;
      return (el = document.getElementById(id)).parentNode.removeChild(el);
    },

    bind: function(fn, context) {
      var args;
      var slice;
      var proxy;

      slice = Array.prototype.slice;
      args  = slice.call(arguments, 2);

      if (args.length) {
        proxy = function() {
          return arguments.length ?
            fn.apply(context, args.concat(slice.call(arguments))) :
            fn.apply(context, args);
        };
      }
      else {
        proxy = function() {
          return arguments.length ?
            fn.apply(context, arguments) :
            fn.call(context);
        };
      }

      return proxy;
    },

    _guid: 0,

    guid: function() {
      return 'UNII-' + (this._guid++) + '-' + new Date().getTime();
    },

    on: function(element, event, fn) {
      if (document.addEventListener) {
        element.addEventListener(event, fn, false);
      }
      else if (document.attachEvent) {
        element.attachEvent('on' + event, fn);
      }
    },

    off: function(element, event, fn) {
      if (document.removeEventListener) {
        element.removeEventListener(event, fn, false);
      }
      else if (document.detachEvent) {
        element.detachEvent(event, fn);
      }
    },

    ready: function(fn) {
      switch (document.readyState) {
        case 'loaded':
        case 'interactive':
        case 'complete':
          fn();
          break;

        default:
          if (document.DOMContentLoaded) {
            UNII.on(document, 'DOMContentLoaded', fn);
          }
          else {
            UNII.on(window, 'load', fn);
          }
          break;
      }
    },

    cancelEvent: function (event) {
      if (event && event.preventDefault) {
        event.preventDefault();
      }
      else {
        window.event.returnValue = false;
      }
    },

    // TODO GIANNI: Move to `Modal`
    close: function (event) {
      var modal;

      if (event)  {
        UNII.cancelEvent(event);
      }

      document.body.className = document.body.className.replace(/unii-no-scroll/g, '');

      if (modal = UNII.activeModal) {
        UNII.activeModal.hide();
        document.dispatchEvent(new CustomEvent('unii:closed', { detail: modal }));
      }
    }
  };


  //-----------------------------------------------------------------------------
  // Modal
  //-----------------------------------------------------------------------------

  /* Modal initialization
   *  - assigns listing id to id
   *  - creates a GUID
   *  - injects id into the modal registry
   *  - copies query params from outer window dom
   *
   * @returns {undefined}
   */
  UNII.Modal = function Modal(url, queryParams) {
    var self;
    var id;

    id = url.match(/universe.com\/(?:listings|l|events)\/([^/?#]+)/)[1];

    if (!id) { return; }

    if (self = this.constructor.registry[id]) {
      return self;
    }

    this.constructor.registry[id] = this;

    this.guid = UNII.guid();
    this.id   = id;
    this.url  = url;

    if (queryParams) {
      this.queryParams = queryParams;
    }
  };

  /* An object to maintain the set of initialized Modals
   *
   * @returns {object}
   */
  UNII.Modal.registry = {};

  /* Modal prototype, provides `hide` and `show` instance methods
   *
   * @returns {object}
   */
  UNII.Modal.prototype = {
    constructor: UNII.Modal,

    /* Sets display to none on the iframe and removes UNII.activeModal
     *
     * @returns {undefined}
     */
    hide: function() {
      this.el.style.display = 'none';

      if (UNII.activeModal === this) {
        delete UNII.activeModal;
      }
    },

    /* Injects an iframe into the DOM with the appropriate `src` attribute - as determined by
     * this.id, assigned in the constructor, sets UNII.activeModal to this Modal, and dispatches
     * a `unii:opened` event to the window
     *
     * @returns {undefined}
     */
    show: function(event) {
      var src;

      src = 'https://www.universe.com/embed/listings/' + this.id + '/bookings/new' + '?modal=1&guid=' + this.guid;

      if (this.queryParams) {
        src += '&' + this.queryParams;
      }

      if (event) {
        UNII.cancelEvent(event);
      }

      // XXX Mobile vs. desktop approach
      if (navigator.userAgent.match(/Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile|MSIE 9.0/i)) {
        window.location.assign(src);
        return;
      }

      if (this.el) {
        this.el.querySelector('iframe').src = src;
      }
      else {
        this.el = UNII.create([
          '<div class="unii-widget-wrapper">',
            '<iframe class="unii-widget-iframe" src="' + src + '" data-guid="' + this.guid + '" allowtransparency="true" scrolling="no" width="100%" height="100%"></iframe>',
          '</div>'
        ].join(''));
      }

      document.body.className += ' unii-no-scroll ';
      this.el.style.display = 'block';
      UNII.activeModal = this;

      document.dispatchEvent(new CustomEvent('unii:opened', { detail: this }));
    }
  };


  //-----------------------------------------------------------------------------
  // Export
  //-----------------------------------------------------------------------------

  window.UNII = UNII;

  // Legacy
  window.UniiEmbeddableWidget      = UNII;
  window.UniiEmbeddableWidgetModal = UNII.Modal;


  //-----------------------------------------------------------------------------
  // Main
  //-----------------------------------------------------------------------------

  /* Returns a URIdecoded String in the current domain's cookie
   *
   * @params {String} key Cookie name
   *
   * @returns {String}
   */
  function getCookie(key) {
    var match = document.cookie.match(new RegExp(key + '=([^;]+)'));
    if (match && match[1]) {
      return decodeURIComponent(match[1]);
    }
  }

  var getQueryParam = (function(){
    var i;
    var p = window.location.search.slice(1).split('&');
    var v;
    var params = {};

    for (i = 0; i < p.length; i++) {
      v = p[i].split('=');
      params[v[0]] = v[1] ? v[1] : true;
    }

    return function(name) {
      return params[name];
    };
  })();

  var DELIMITER = '(╯°□°）╯︵';
  var PREFIX    = 'ノ( º _ ºノ)';

  /* Decodes messages sent from child iframes via postMessage
   *
   * @params {event.data} rawMessage
   *
   * @returns {Object}
   */
  function decodeMessage(rawMessage) {
    if (!rawMessage) { return; }

    var i;
    var message;
    var options;

    options = {};
    (message = rawMessage.split(PREFIX)).shift();

    if (message.length > 1) {
      options.guid = message.shift();
    }

    message = message[0].split(DELIMITER);

    for (i = 0; i < message.length; i++) {
      message[i] = JSON.parse(message[i]);
    }

    return {
      message:   message.shift(),
      arguments: message,
      options:   options,
      raw:       rawMessage
    };
  }

  /* Encodes a message in preparation for sending it to a child iframe(s). If options.guid is provided,
   * the message is prefixed with the GUID
   *
   * @param {Array} items
   * @param {Object} options
   *
   * @returns {String}
   */
  function encodeMessage(items, options) {
    if (!options) { options = {}; }

    var i;
    var args;
    var message;

    args = [];
    message = PREFIX;

    if (options.guid) {
      message += options.guid;
      message += PREFIX;
    }

    for (i = 0; i < items.length; i++) {
      args[i] = JSON.stringify(items[i]);
    }

    message += args.join(DELIMITER);

    return message;
  }

  /* Receive's a message via postMessage, passes the message to `decodeMessage` and reacts to its content
   * Supported events:
   *  - `booking-new` opens a new modal
   *  - `close` closes the activeModal
   *  - `ready` notifies the outer DOM of the inner frame's ready state
   *  - `scroll-to-top` scrolls to #unii-embed-page
   *  - `unii-route` captures route transitions from the iframe's app, and emits custom events as appropriate
   *  - `window-height` communicates the iframe's inner DOM height
   *
   * @param {Event} event
   */
  function receiveMessage(event) {
    if (event.origin.indexOf('https://www.universe.com') !== 0) { return; }
    if (typeof event.data !== 'string') { return; }
    if (event.data.indexOf(PREFIX) !== 0) { return; }

    var decoded;

    decoded = decodeMessage(event.data);

    // TODO: Move to {Object.<string, function>}
    switch (decoded.message) {
      case 'booking-new':
        // Do not open deprecated the Embed modal, Juno will open instead
        // UNII.createModal({listing_id: decoded.arguments[0]});
        break;

      case 'close':
        if (!UNII.activeModal) { return; }

        UNII.close();
        break;

      case 'ready':
        if (getCookie('uniiverse_ref')) {
          event.source.postMessage(encodeMessage(['ref', getCookie('uniiverse_ref')]), 'https://www.universe.com');
        }
        event.source.postMessage(encodeMessage(['host', window.location.host]), 'https://www.universe.com');
        if (clientId = getCookie('_ga')) {
          event.source.postMessage(encodeMessage(['google-analytics', clientId]), 'https://www.universe.com');
        }
        break;

      // TODO GIANNI: FIX
      case 'scroll-to-top':
        window.location.href = '#unii-embed-page';
        break;

      case 'unii-route':
        if (!UNII.activeModal) { return; }

        if (decoded.arguments[0] === 'ticket') {
          UNII.activeIframeTicketId = decoded.arguments[1];
          var evt = new CustomEvent('unii:ticket:purchased', { detail: decoded.arguments[2] });
          document.dispatchEvent(evt);
        }
        break;

      case 'window-height':
        adjustHeight(decoded.arguments[0], decoded.options);
        break;

    }
  }

  /* Determines if the user is using Internet Explorer
   *
   * @returns {Boolean}
   */
  function isIE() {
    var myNav = navigator.userAgent.toLowerCase();
    return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
  }

  /* Sets the specified iframe's height to a numeric value
   *
   * @param {Number} height
   * @param {Object} options
   *
   * @returns {Undefined}
   */
  function adjustHeight(height, options) {
    if (!options || !options.guid) { return; }
    if (!height) { height = 240; }

    var iframe;

    if (iframe = document.querySelector('iframe[data-guid="' + options.guid + '"]')) {
      iframe.style.height = height + 'px';
    }
  }

  // Store `ref` code if present
  var refCode;
  if (refCode = getQueryParam('ref')) {
    document.cookie = 'uniiverse_ref=' + encodeURIComponent(refCode.toLowerCase()) + '; expires=Fri, 31 Dec 2037 23:59:59 GMT; path=/';
  }

  // Communication broker
  UNII.on(window, 'message', receiveMessage);

  // Close modal on escape
  UNII.on(document, 'keydown', function(event) {
    if (event.keyCode === 27) {
      UNII.close();
    }
  });

  // Modal click handler
  // UNII.on(document, 'click', function(event) {
  //   if (window.location.host.replace(/^www\./, '') === 'universe.com') { return; }

  //   var element = event.target;

  //   do {
  //     if (element.tagName === 'A') { break; }
  //   } while(element = element.parentNode);

  //   // Sanity checks
  //   if (!element) { return; }
  //   if (element.className.indexOf('unii-skip') !== -1) { return; }

  //   if (/universe.com\/(?:listings|l|events)\/([^/?#]+)/.test(element.href)) {
  //     event.preventDefault();
  //     var queryParams = buildQueryParams();
  //     // new UNII.Modal(element.href, queryParams).show();
  //   }
  // });

  // Assign GUIDs to iframes and fix erroneous src URLs.
  // TODO add analytics here to see if we're still using the incorrect page URLS
  (function(){
    var loop;
    var embedSrc;
    var hashRoute;
    var iframes;
    var incorrectPageSrc;

    iframes = document.getElementsByTagName('iframe');
    embedSrc = new RegExp('(?:https://www.universe.com/embed|https://www.uniiverse.com/embed)');
    hashRoute = /#(\/.+)$/;
    incorrectPageSrc = new RegExp('universe.com/pages/([A-Za-z0-9_-]+\/?([0-9]+)?)$');

    loop = setInterval(function(){
      var a;
      var guid;
      var hashRouteMatch;
      var i;
      var src;

      a = document.createElement('a');

      for (i = 0; i < iframes.length; i++) {
        src = iframes[i].getAttribute('src');

        if (!src || iframes[i].getAttribute('data-guid')) {
          continue;
        }

        // Correct src URLs
        if (incorrectPageSrc.test(src)) {
          src = 'https://www.universe.com/embed/pages/' + incorrectPageSrc.exec(src)[1];
        }
        else if (embedSrc.test(src)) {
          // Update legacy hash-based URLs
          if (hashRoute.test(src)) {
            hashRouteMatch = hashRoute.exec(src)[1];
            src = 'https://www.universe.com/embed' + hashRouteMatch;

            // Re-add hash for IE < 10
            if (isIE() && isIE() < 10) {
              src += '#' + hashRouteMatch;
            }
          }
        }
        else {
          continue;
        }

        // Set GUID
        guid = UNII.guid();
        iframes[i].setAttribute('data-guid', guid);

        a.href = src;
        a.search += (a.search.length ? '&' : '?') + 'guid=' + guid;
        iframes[i].src = a.href;

        // Set full width
        if (!iframes[i].hasAttribute('width')) {
          iframes[i].setAttribute('width', '100%');
        }
      }

      a = undefined;
    }, 50);

    UNII.ready(function() {
      setTimeout(function(){ clearInterval(loop); }, 51);
    });
  })();

  /*
  var triggerOpen;
  if (triggerOpen = getQueryParam('unii-trigger-open')) {
    var queryParams = buildQueryParams();
    new UNII.Modal('https://www.universe.com/listings/' + triggerOpen, queryParams).show();
  }
  */

  /* Builds a queryParams object used by Modal
   *
   * @returns {Object}
   */
  function buildQueryParams() {
    var params = [];
    var accessKey;
    var discountCode;
    var utmMedium;
    var utmSource;
    var utmCampaign;
    var utmTerm;
    var utmName;

    if (accessKey = getQueryParam('unii-access-key')) {
      var accessKeys = accessKey.split(',');
      var i = 0;
      for (i = 0; i < accessKeys.length; i++) {
        params.push(['access_keys[]', encodeURIComponent(accessKeys[i])].join('='));
      }
    }

    if (discountCode = getQueryParam('unii-discount-code')) {
      params.push(['listing_params', encodeURIComponent(JSON.stringify({
        discount_code: {
          code: discountCode
        }
      }))].join('='));
    }

    if (utmMedium = getQueryParam('utm_medium')) {
      params.push(['utm_medium', utmMedium].join('='));
    }

    if (utmSource = getQueryParam('utm_source')) {
      params.push(['utm_source', utmSource].join('='));
    }

    if (utmCampaign = getQueryParam('utm_campaign')) {
      params.push(['utm_campaign', utmCampaign].join('='));
    }

    if (utmTerm = getQueryParam('utm_term')) {
      params.push(['utm_term', utmTerm].join('='));
    }

    if (utmName = getQueryParam('utm_name')) {
      params.push(['utm_name', utmName].join('='));
    }

    if (params.length) {
      return params.join('&');
    }
  }
})(window, document);
