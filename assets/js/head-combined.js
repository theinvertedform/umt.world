/*  Create global ‘GW’ object, if need be.
 */
if (typeof window.GW == "undefined")
    window.GW = { };


/*****************/
/* MEDIA QUERIES */
/*****************/

GW.mediaQueries = {
    mobileWidth:           matchMedia("(max-width: 649px)"),
    systemDarkModeActive:  matchMedia("(prefers-color-scheme: dark)"),
    hoverAvailable:        matchMedia("only screen and (hover: hover) and (pointer: fine)"),
    portraitOrientation:   matchMedia("(orientation: portrait)"),
    printView:             matchMedia("print")
};

GW.isMobile = () => {
    /*  We consider a client to be mobile if one of two conditions obtain:
        1. JavaScript detects touch capability, AND viewport is narrow; or,
        2. CSS does NOT detect hover capability.
     */
    return (   (   ("ontouchstart" in document.documentElement)
                && GW.mediaQueries.mobileWidth.matches)
            || !GW.mediaQueries.hoverAvailable.matches);
};

GW.isFirefox = () => {
    return (navigator.userAgent.indexOf("Firefox") > 0);
};

GW.isTorBrowser = () => {
    return (("serviceWorker" in navigator) == false);
};

GW.isX11 = () => {
    return (navigator.userAgent.indexOf("X11") > 0);
};


/********************/
/* DEBUGGING OUTPUT */
/********************/

GW.dateTimeFormat = new Intl.DateTimeFormat([], { hour12: false, hour: "numeric", minute: "numeric", second: "numeric" });

function GWTimestamp() {
    let time = Date.now();
    let ms = `${(time % 1000)}`.padStart(3,'0');
    let timestamp = `${GW.dateTimeFormat.format(time)}.${ms}`;

    return timestamp;
}

GW.logLevel = localStorage.getItem("gw-log-level") || 0;
GW.logSourcePadLength = 28;

function GWLog (string, source = "", level = 1) {
    if (GW.logLevel < level)
        return;

    let sourcestamp = (source > "" ? `[${source}]` : `[ ]`).padEnd(GW.logSourcePadLength, ' ');

    let outputString = (`[${GWTimestamp()}]  ` + sourcestamp + string);

    console.log(outputString);
}
GW.setLogLevel = (level, permanently = false) => {
    if (permanently)
        localStorage.setItem("gw-log-level", level);

    GW.logLevel = level;
};

function GWStopWatch(f, ...args) {
    let fname = (f.name || f.toString().slice(0, f.toString().indexOf('{')));
    console.log(`[${GWTimestamp()}]  ${fname} [BEGIN]`);
    let rval = f(...args);
    console.log(`[${GWTimestamp()}]  ${fname} [END]`);
    return rval;
}


/*******************/
/* ERROR REPORTING */
/*******************/

/*  Reports an error by sending an XMLHTTPRequest to the 404 page, suffixed
    with some error string (which gets automatically URL-encoded).

    (Requires utility.js.)
 */
function GWServerLogError(errorString, errorType) {
    doAjax({ location: `${location.origin}/404-error-` + fixedEncodeURIComponent(errorString) });
    GWLog(`Reporting ${(errorType || "error")}:  ${errorString}`, "error reporting", 1);
}


/************************/
/* ACTIVE MEDIA QUERIES */
/************************/

/*  This function provides two slightly different versions of its functionality,
    depending on how many arguments it gets.

    If one function is given (in addition to the media query and its name), it
    is called whenever the media query changes (in either direction).

    If two functions are given (in addition to the media query and its name),
    then the first function is called whenever the media query starts matching,
    and the second function is called whenever the media query stops matching.

    If you want to call a function for a change in one direction only, pass an
    empty closure (NOT null!) as one of the function arguments.

    There is also an optional fifth argument. This should be a function to be
    called when the active media query is canceled.
 */
function doWhenMatchMedia(mediaQuery, name, ifMatchesOrAlwaysDo, otherwiseDo = null, whenCanceledDo = null) {
    if (typeof GW.mediaQueryResponders == "undefined")
        GW.mediaQueryResponders = { };

    let mediaQueryResponder = (event, canceling = false) => {
        if (canceling) {
            GWLog(`Canceling media query “${name}”`, "media queries", 1);

            if (whenCanceledDo != null)
                whenCanceledDo(mediaQuery);
        } else {
            let matches = (typeof event == "undefined") ? mediaQuery.matches : event.matches;

            GWLog(`Media query “${name}” triggered (matches: ${matches ? "YES" : "NO"})`, "media queries", 1);

            if ((otherwiseDo == null) || matches)
                ifMatchesOrAlwaysDo(mediaQuery);
            else
                otherwiseDo(mediaQuery);
        }
    };
    mediaQueryResponder();
    mediaQuery.addListener(mediaQueryResponder);

    GW.mediaQueryResponders[name] = mediaQueryResponder;
}

/*  Deactivates and discards an active media query, after calling the function
    that was passed as the whenCanceledDo parameter when the media query was
    added.
 */
function cancelDoWhenMatchMedia(name) {
    if (GW.mediaQueryResponders[name] == null)
        return;

    GW.mediaQueryResponders[name](null, true);

    for (let [ key, mediaQuery ] of Object.entries(GW.mediaQueries))
        mediaQuery.removeListener(GW.mediaQueryResponders[name]);

    GW.mediaQueryResponders[name] = null;
}


/***********/
/* HELPERS */
/***********/

/*******************************************************************************/
/*  Product of two string arrays. (Argument can be a string, which is equivalent
    to passing an array with a single string member.)
    Returns array whose members are all results of concatenating each left hand
    array string with each right hand array string, e.g.:

        [ "a", "b" ].π([ "x", "y" ])

    will return:

        [ "ax", "ay", "bx", "by" ]

    Any non-string argument must be iterable, else null is returned. Any
    members of a passed array (or other iterable object), whatever their types,
    are stringified and interpolated into the resulting product strings.
 */
Array.prototype.π = function (strings) {
    if (typeof strings == "string")
        strings = [ strings ];

    if (!!strings[Symbol.iterator] == "false")
        return null;

    let product = [ ];
    for (let lhs of this) {
        for (let rhs of strings) {
            product.push(`${lhs}${rhs}`);
        }
    }
    return product;
};

/*****************************************************************************/
/*  As Array.π, but applies sequentially to each argument. (First argument may
    be a string, which is impossible with the Array member version.)
 */
function _π(...args) {
    if (args.length == 0)
        return [ ];

    let product = [ "" ];
    for (let arg of args)
        product = product.π(arg);

    return product;
}


/*************/
/* DOCUMENTS */
/*************/

/*  Return the location (URL) associated with a document.
    (Document|DocumentFragment) => URL
 */
function baseLocationForDocument(doc) {
    if (doc == null) {
        return null;
    } else if (doc == document) {
        return URLFromString(location.href);
    } else if (doc.baseLocation) {
        return URLFromString(doc.baseLocation.href);
    } else {
        return null;
    }
}


/*****************/
/* NOTIFICATIONS */
/*****************/
/*  The GW.notificationCenter object allows us to register handler functions for
    named events. Any number of handlers may be registered for any given named
    event, and when that event is fired, all of its registered handlers will be
    called. Because event handlers are registered for events by event name
    (which may be any string we like), a handler may be registered for an event
    at any time and at any location in the code. (In other words, an event does
    not need to first be “defined”, nor needs to “exist” in any way, in order
    for a handler to be registered for it.)

    We can also make the calling of any given event handler conditional (with a
    user-defined, handler-specific condition function [closure] that dynamically
    determines whether its associated handler should be called or not, when the
    event the handler was registered for is fired), specify that an event
    handler should be called only once or many times, and group handlers for a
    particular event into named “phases” (to ensure that certain handlers for an
    event are always called before/after others).

    Events themselves are also user-defined. Causing an event to fire is as
    simple as calling GW.notificationCenter.fireEvent() and providing an event
    name (which may be any string), plus an event info dictionary (which may
    contain any keys and values we deem necessary, and which will be passed to
    the handler functions); this will trigger the calling of all the handlers
    that have been registered for that event name.

    See the comments on specific elements of GW.notificationCenter, below, for
    more information.
 */
GW.notificationCenter = {
    /*  Dictionary of registered event handlers for named events.

        KEYS are event names (e.g. ‘GW.contentDidLoad’).

        VALUES are arrays of handler definitions for each event. Each handler
        definition is a dictionary with the following keys/values:

        - ‘f’ (key)
            Handler function to call when the named event fires (passing the
            event info dictionary of the fired event). (See comment on the
            ‘addHandlerForEvent’ function, below, for details.)

        - ‘options’ (key) [optional]
            Event options dictionary, with the following keys/values:

            - ‘condition’ (key) [optional]
                Test function, to which the event info dictionary of the fired
                event is passed; the handler function is called if (and only if)
                the condition returns true.

            - ‘once’ (key) [optional]
                Boolean value; if true, the handler will be removed after the
                handler function is called once (note that if there is a
                condition function provided [see the ‘condition’ key], the
                handler function will not be called - and therefore will not be
                removed - if the named event is fired but the condition
                evaluates to false).

                If not set, defaults to false (ie. by default a handler is
                not removed after an event is fired once, but will continue to
                be invoked each time the named event fires and the condition,
                if any, evaluates as true).

            - ‘phase’ (key) [optional]
                String which specifies when the given handler function should be
                called, relative to other handlers registered for the named
                event.

                The format for this string is as follows:

                - If the entire string is equal to “<”, then the given handler
                  function will be called prior to any handlers that are
                  assigned to any other phase (or to no specific phase). (Within
                  this “before all others” ‘pseudo-phase’, handlers are called
                  in the order in which they were added.)

                - If the entire string is equal to “>”, then the given handler
                  function will be called after any handlers that are assigned
                  to any other phase (or to no specific phase). (Within this
                  “after all others” ‘pseudo-phase’, handlers are called in the
                  order in which they were added.)

                - If the string is empty, then the given handler function will
                  be called after all other handlers, but before any handlers
                  that were assigned to phase “>”. (Within this “no particular
                  phase” ‘pseudo-phase’, handlers are called in the order in
                  which they were added.)

                - If the first character is anything other than ‘<’ or ‘>’, the
                  entire string is treated as the name of a handler phase. The
                  given handler function will be called in the same handler
                  phase as all other handlers assigned to that phase. (Within a
                  phase, handlers are called in the order in which they were
                  added.)

                - If the first character is ‘<’, then the rest of the string
                  is treated as the name of a handler phase. The given handler
                  function will be called prior to any handlers assigned to the
                  specified phase, but after any handlers assigned to an earlier
                  named phase (if any). (Within such a “before phase X”
                  ‘pseudo-phase’, handlers are called in the order in which they
                  were added.)

                - If the first character is ‘>’, then the rest of the string
                  is treated as the name of a handler phase. The given handler
                  function will be called after any handlers assigned to the
                  specified phase, but before any handlers assigned to a later
                  named phase (if any). (Within such an “after phase X”
                  ‘pseudo-phase’, handlers are called in the order in which they
                  were added.)

        When an event is fired, any handlers registered for that event (ie.
        members of the array which is the value for that event’s name in the
        eventHandlers dictionary) are called in array order. (If a condition is
        specified for any given handler, the handler function is only called if
        the condition function - called with the event info dictionary as its
        argument - evaluates true.)

        The order of an event handlers array for a given event is, by default,
        determined by the order in which handlers are registered for that event.
        The value of the ‘phase’ key of an event’s options dictionary can
        override and modify this default order. (See definition of the ‘phase’
        key of an event handler options dictionary, above.)
     */
    eventHandlers: { },

    /*  Defined event handler phases for certain named events.
        (See definition of the ‘phase’ key of an event handler options
         dictionary, above, for more info.)

        Phases are defined in execution order. For example, consider a
        hypothetical GW.exampleDidHappen event, whose handler phases are defined
        as follows: `[ "foo", "bar" ]`. When the GW.exampleDidHappen event
        fires, event handlers are called in the following order:

        1. Handlers assigned to be called before all other phases (ie. those
           with ‘<’ as the value of their ‘phase’ key in their event handler
           options dictionary)
        2. Handlers assigned to be called before the ‘foo’ phase (ie.
           those with ‘<foo’ as the value of their ‘phase’ key in their
           event handler options dictionary)
        3. Handlers assigned to be called during the ‘foo’ phase (ie.
           those with ‘foo’ as the value of their ‘phase’ key in their
           event handler options dictionary)
        4. Handlers assigned to be called after the ‘foo’ phase (ie.
           those with ‘>foo’ as the value of their ‘phase’ key in their
           event handler options dictionary)
        5. Handlers assigned to be called before the ‘bar’ phase
           (ie. those with ‘<bar’ as the value of their ‘phase’ key
           in their event handler options dictionary)
        6. Handlers assigned to be called during the ‘bar’ phase
           (ie. those with ‘bar’ as the value of their ‘phase’ key
           in their event handler options dictionary)
        7. Handlers assigned to be called after the ‘bar’ phase
           (ie. those with ‘>bar’ as the value of their ‘phase’ key
           in their event handler options dictionary)
        8. Handlers assigned to be called after all other phases (ie. those
           with ‘>’ as the value of their ‘phase’ key in their event handler
           options dictionary)

        (Handlers with no specified phase might be called at any point after
         step 1 and before step 8 in this sequence, depending on when they were
         registered.)
     */
    handlerPhaseOrders: { },

    /*  Register a new event handler for the named event. Arguments are:

        - ‘eventName’
            The name of an event (e.g. ‘GW.contentDidLoad’).

        - ‘f’
            Event handler function. When the event fires, this function will be
            called. Note that if a condition is specified in the event handler
            options (i.e. if a condition function is provided as the value of
            the ‘condition’ key in the event handler options dictionary), then
            the handler function will be called only if the condition function
            evaluates true).

            The event handler function should take one argument: an event info
            dictionary. The keys and values of this dictionary are mostly
            event-specific (but see the ‘fireEvent’ function, below, for more
            info).

        - ‘options’ [optional]
            Event handler options dictionary. See comment on the ‘eventHandlers’
            property (above) for info on possible keys/values.

        Note that if there already exists a registered event handler for the
        given event with the same event handler function as the new handler that
        you are trying to register, then the new handler will not be registered
        (even if it has different handler options than the existing handler).
     */
    addHandlerForEvent: (eventName, f, options) => {
        options = Object.assign({
            condition: null,
            once: false,
            phase: ""
        }, options);

        /*  If this event is currently firing, do not add the handler yet.
            Instead, add it to the waiting list. It will be added once the event
            has finished firing.
         */
        if (GW.notificationCenter.currentEvents.includes(eventName)) {
            if (GW.notificationCenter.waitingHandlers[eventName] == null)
                GW.notificationCenter.waitingHandlers[eventName] = [ ];

            GW.notificationCenter.waitingHandlers[eventName].push({ f: f, options: options });

            return;
        }

        /*  If there’s not already a handlers array for the given event (which
            may be, e.g. because no event handlers have yet been registered
            for this event), create the array.
         */
        if (GW.notificationCenter.eventHandlers[eventName] == null)
            GW.notificationCenter.eventHandlers[eventName] = [ ];

        /*  Array of registered handlers for the named event. Might be empty
            (if no handlers have been registered for this event yet).
         */
        let handlers = GW.notificationCenter.eventHandlers[eventName];

        /*  If there is already a registered handler with the same handler
            function as the one we’re trying to register, do not register this
            new one (even if it has different handler options).
         */
        if (handlers.findIndex(handler => handler.f == f) !== -1)
            return;

        /*  Get the handler phase order for the named event, if any. (Add to it
            the built-in phases “<” and “>”.)
         */
        let phaseOrder = [ "<", ...(GW.notificationCenter.handlerPhaseOrders[eventName] ?? [ ]), ">" ];

        /*  Get the target phase name, which may be the full value of the
            ‘phase’ key of the options dictionary, OR it may be that value
            minus the first character (if the value of the ‘phase’ key
            begins with a ‘<’ or a ‘>’ character).
            */
        let targetPhase = options.phase.match(/^([<>]?)(.+)?/)[2];

        /*  Get the index of the target phase in the defined handler phase
            order for the named event.
         */
        let targetPhaseIndex = phaseOrder.indexOf(targetPhase);

        /*  Takes an index into the given event’s handler array. Returns a
            dictionary with these keys/values:

            - ‘phase’ [key]
                The name of the phase to which the handler at the given
                index is assigned (could be an empty string).

            - ‘before’ [key]
                Boolean value; true if the handler at the given index is
                assigned to run before the specified phase, false otherwise
                (ie. if it’s instead assigned to run either during or
                after the specified phase).

            - ‘after’ [key]
                Boolean value; true if the handler at the given index is
                assigned to run after the specified phase, false otherwise
                (ie. if it’s instead assigned to run either before or
                during the specified phase).

            (Note that for an event handler which has not been assigned to
             any specific phase, ‘phase’ will be the empty string, and both
             ‘before’ and ‘after’ will be false.)

            Returns null if the given index is out of bounds of the event’s
            handler definitions array.
         */
        let phaseAt = (index) => {
            if (index >= handlers.length)
                return null;
            let parts = handlers[index].options.phase.match(/^([<>]?)(.*)$/);
            return (parts[2] > ""
                    ? { phase: parts[2],
                        before: (parts[1] == "<"),
                        after: (parts[1] == ">") }
                    : { phase: parts[1] });
        };

        //  Where in the handlers array to insert the new handler?
        let insertAt;
        if (options.phase == "<") {
            /*  If the handler we’re registering is assigned to phase “<” (i.e.,
                is specified to run before all others), it’s inserted
                immediately after all other handlers already likewise specified.
             */
            for (var i = 0; i < handlers.length; i++) {
                if (phaseAt(i).phase != "<")
                    break;
            }

            insertAt = i;
        } else if (options.phase == ">") {
            /*  If the handler we’re registering is assigned to phase “>” (i.e.,
                is specified to run after all others), it’s inserted immediately
                after all other handlers already so specified (i.e., at the very
                end of the handlers array).
             */
            insertAt = handlers.length;
        } else if (   options.phase == ""
                   || targetPhaseIndex == -1) {
            /*  If the handler we’re registering isn’t assigned to any
                particular handler phase, or if it’s assigned to a phase that
                does not actually exist in this event’s handler phase order,
                we will add it just before all handlers of phase “>” (i.e.,
                those handlers specified to be called after all others).
             */
            for (var j = 0; j < handlers.length; j++) {
                if (phaseAt(j).phase == ">")
                    break;
            }

            insertAt = j;
        } else {
            /*  The handler is specified to run before, during, or after a named
                phase (i.e., not “<” or “>”) that (as we’ve confirmed already)
                exists in this event’s defined handler phase order.
             */

            if (options.phase.startsWith("<")) {
                /*  The handler is assigned to be called before the specified
                    phase.
                 */
                for (var k = 0; k < handlers.length; k++) {
                    /*  We have found the index before which to insert, if the
                        handler at this index is assigned to be called during
                        or after our target phase, OR if it is assigned to be
                        called before, during, or after any later phase.

                        (In other words, we have passed all the handlers which
                         are assigned either to any earlier phase or to before
                         the specified phase.)
                     */
                    let phaseAtThisIndex = phaseAt(k);
                    if (   (   phaseAtThisIndex.phase == targetPhase
                            && phaseAtThisIndex.before == false)
                        || phaseOrder.slice(targetPhaseIndex + 1).includes(phaseAtThisIndex.phase))
                        break;
                }

                insertAt = k;
            } else if (options.phase.startsWith(">")) {
                /*  The handler is assigned to be called after the specified
                    phase.
                 */
                for (var m = handlers.length - 1; m > -1; m--) {
                    /*  We have found the index _after_ which to insert (hence
                        the `m++`), if the handler at this index is assigned to
                        be called before, during, or after the target phase, OR
                        if it is assigned to be called before, during, or after
                        any earlier phase.

                        (In other words, we have passed - moving backwards
                         through the handlers array - all the handlers which
                         are assigned to any later phase.)
                     */
                    let phaseAtThisIndex = phaseAt(m);
                    if (   phaseAtThisIndex.phase == targetPhase
                        || phaseOrder.slice(0, targetPhaseIndex - 1).includes(phaseAtThisIndex.phase)) {
                        m++;
                        break;
                    }
                }

                insertAt = m;
            } else {
                /*  The handler is assigned to be called during the specified
                    phase.
                 */
                for (var n = 0; n < handlers.length; n++) {
                    /*  We have found the index before which to insert, if the
                        handler at this index is assigned to be called after the
                        target phase, OR if it is assigned to be called before,
                        during, or after any later phase.

                        (In other words, we have passed all the handlers which
                         are assigned either to any earlier phase or to before
                         or during the specified phase.)
                     */
                    let phaseAtThisIndex = phaseAt(n);
                    if (   (   phaseAtThisIndex.phase == targetPhase
                            && phaseAtThisIndex.after == true)
                        || phaseOrder.slice(targetPhaseIndex + 1).includes(phaseAtThisIndex.phase))
                        break;
                }

                insertAt = n;
            }
        }

        /*  Add the new event handler to the named event’s handler definitions
            array, at whatever index we have now determined it should go to.
         */
        GW.notificationCenter.eventHandlers[eventName].splice(insertAt, 0, { f: f, options: options });
    },

    /*  Unregister the event handler with the given handler function from the
        specified named event (if such a handler exists).
     */
    removeHandlerForEvent: (eventName, f) => {
        if (GW.notificationCenter.eventHandlers[eventName] == null)
            return;

        GW.notificationCenter.eventHandlers[eventName].removeIf(handler => handler.f === f);
    },

    /*  Unregister all registered event handlers from the specified named event.
     */
    removeAllHandlersForEvent: (eventName) => {
        GW.notificationCenter.eventHandlers[eventName] = null;
    },

    /*  Event-specific pre-fire processing functions. Keys are event names.
        Values are functions that take the event info as an argument, and return
        modified event info.
    */
    prefireProcessors: { },

    /*  Array of events that are currently being fired. Used to avoid adding a
        handler to an event while it’s firing.
     */
    currentEvents: [ ],

    /*  Arrays (keyed to event names) of event handlers waiting to be added to
        events. A handler waits here if its addHandlerForEvent() call happened
        while the target event was firing. The handler will be added once the
        event has finished firing.
     */
    waitingHandlers: { },

    /*  Add all waiting handlers for the event, if any.
     */
    addWaitingHandlersForEvent: (eventName) => {
        if (GW.notificationCenter.waitingHandlers[eventName]) {
            GW.notificationCenter.waitingHandlers[eventName].forEach(handler => {
                if (handler.f) {
                    GW.notificationCenter.addHandlerForEvent(eventName, handler.f, handler.options);
                    handler.f = null;
                }
            });
            GW.notificationCenter.waitingHandlers[eventName] = GW.notificationCenter.waitingHandlers[eventName].filter(handler => handler.f);
        }
    },

    /*  Fire an event with the given name and event info dictionary.

        In addition to printing a console log message (if the log level is set
        to 1 or higher), this will also cause each event handler that has been
        registered for the named event to be called. (Handlers with a condition
        function specified in their event handler options will first have that
        condition function called, and the handler function will only be called
        if the condition evaluates true.)

        The event info dictionary provided to the ‘fireEvent’ function will be
        passed as the argument to each handler function (as well as to any
        condition function that is called to determine whether a handler should
        be called).

        The event info dictionary may contain various, mostly event-specific,
        keys and values. The one common key/value that any event’s info
        dictionary may contain is the ‘source’ key, whose value should be a
        string identifying the function, browser event, or other context which
        caused the given event to be fired (such as ‘DOMContentLoaded’ or
        ‘Annotations.load’). In addition to any ways in which it may be used
        by an event handler, this string (i.e. the value of the ‘source’ key)
        is (if present) included in the console message that is printed when the
        event is fired.
     */
    fireEvent: (eventName, eventInfo = { }) => {
        if (eventName == null)
            return;

        //  Register this event as currently being fired.
        GW.notificationCenter.currentEvents.push(eventName);

        /*  Store event name in info dictionary, so that event handlers can
            access it. (This permits, e.g. the same handler to handle multiple
            events, and conditionally select behavior based on which event is
            calling the handler.)
         */
        eventInfo.eventName = eventName;

        /*  The ‘16’ here is the width of the date field plus spacing.
            The “Source:” text is manually padded to be as wide
            as “[notification]”.
         */
        GWLog(`Event “${eventName}” fired.`
            + `${((eventInfo && eventInfo.source)
                  ? ("\n"
                   + "".padStart(16, ' ')
                   + "       Source:".padEnd(GW.logSourcePadLength, ' ')
                   + eventInfo.source)
                  : ""
                 )}`, "notification");

        /*  If event-specific pre-fire processing is needed, do it.
         */
        if (GW.notificationCenter.prefireProcessors[eventName])
            eventInfo = GW.notificationCenter.prefireProcessors[eventName](eventInfo);

        /*  Call all registered handlers (if any), in order.
         */
        if (GW.notificationCenter.eventHandlers[eventName]) {
            for (let i = 0; i < GW.notificationCenter.eventHandlers[eventName].length; i++) {
                let handler = GW.notificationCenter.eventHandlers[eventName][i];
                /*  If a condition function is provided, call it to determine
                    whether the handler function should be called.
                 */
                if (   handler.options.condition
                    && handler.options.condition(eventInfo) == false)
                    continue;

                /*  If the condition function evaluated true, or if no condition
                    function was provided, we call the handler.
                 */
                handler.f(eventInfo);

                /*  If the handler options specified a true value for the ‘once’
                    key, we unregister this handler after having called it once.

                    (Note that in the case of an once-only handler that’s called
                     conditionally, i.e. one with a specified condition function,
                     regardless of how many times the named event fires, the handler
                     is never automatically removed until its condition evaluates
                     true and the handler actually gets called once.)
                 */
                if (handler.options.once) {
                    GW.notificationCenter.eventHandlers[eventName].splice(i, 1);
                    i--;
                }
            }
        }

        //  Unregister this event from the list of events currently being fired.
        GW.notificationCenter.currentEvents.remove(eventName);

        //  Add any handlers that are waiting to be added.
        GW.notificationCenter.addWaitingHandlersForEvent(eventName);
    }
};


/**************************/
/* LOAD & INJECT HANDLERS */
/**************************/

/*******************************************************************************/
/*  NOTE on the GW.contentDidLoad and GW.contentDidInject events:

    These events are fired whenever any new local page content is loaded and
    injected into the page, respectively. (Here “loaded” may mean “loaded via a
    network request”, “constructed from a template”, or any other process by
    which a new unit of page content is created. This includes the initial page
    load, but also such things as annotations being lazy-loaded, etc. Likewise,
    “injected” may mean “injected into the base page”, “injected into a
    pop-frame shadow-root”, “injected into a DocumentFragment in cache”, etc.)

    Many event handlers are attached to these, because a great deal of
    processing must take place before newly-loaded page content is ready for
    presentation to the user. Typography rectification must take place; the HTML
    structure of certain page elements (such as tables, figures, etc.) must be
    reconfigured; CSS classes must be added; various event listeners attached;
    etc. Most of rewrite.js consists of exactly such “content load handlers” and
    “content inject handlers”, a.k.a. “rewrite functions”. (Additional content
    load and inject handlers are defined elsewhere in the code, as appropriate;
    e.g. the handler that attaches event listeners to annotated links to load
    annotations when the user mouses over such links, which is found in
    extracts-annotations.js.)

    The GW.contentDidLoad event has the following named handler phases (see
    above for details on what this means):

        [ "transclude", "rewrite" ]

    The GW.contentDidInject event has the following named handler phases:

        [ "rewrite", "eventListeners" ]

    The GW.contentDidLoad and GW.contentDidInject events should have the
    following keys and values in their event info dictionary (see above
    for details on event info dictionaries):

        ‘source’ (key) (required)
            String that indicates function (or event name, if fired from a
            browser event listener) from which the event is fired (such as
            ‘Annotation.load’).

        ‘container’ (key) (required)
            DOM object containing the loaded content. (For the GW.contentDidLoad
            event fired on the initial page load, the value of this key is
            `document`, i.e. the root document of the page. For pop-frames, this
            may be the `document` property of the pop-frame, or a
            DocumentFragment containing the embedded page elements.) The
            container will contain nothing but the newly-loaded content.
            (This key can be thought of as “what has been loaded?”.)

        ‘document’ (key) (required)
            Document into which the content was loaded. May or may not be
            identical with the value of the ‘container’ key (in those cases when
            the loaded content is a whole document itself). The value of this
            key is necessarily either a Document (i.e., the root document of the
            page) or a DocumentFragment. (This key can be thought of as “into
            where has the loaded content been loaded?”.)

        ‘contentType’ (key)
            String that indicates content type of the loaded content. Might be
            null (which indicates the default content type: local page content).
            Otherwise may be `annotation` or something else.

        ‘loadLocation’ (key)
            URL object (https://developer.mozilla.org/en-US/docs/Web/API/URL)
            which specifies the URL from which the loaded content was loaded.
            For the main page, the represented URL will be the value of
            `location.href`. For pop-frames, transcludes, etc., the represented
            URL will be that of the page in which the content resides. (If the
            loaded/injected content is not sourced from any page, this key will
            have a null value.)

    The GW.contentDidInject event should additionally have a value for the
    following key:

        ‘flags’ (key) (required)
            Bit field containing various flags (combined via bitwise OR). The
            values of the flags are defined in GW.contentDidInjectEventFlags.

            (Note that event handlers for the ‘GW.contentDidInject’ event can
             access the values of these flags directly via property access on
             the event info, e.g. the following two expressions are equivalent:

               eventInfo.flags & GW.contentDidInjectEventFlags.clickable != 0

               eventInfo.clickable

             It is recommended that the latter form be used.)

            The flags are:

            ‘clickable’
                Currently unused. Reserved for future use.

            ‘stripCollapses’
                Specifies whether the loaded content is permitted to have
                collapsed sections. Generally false. If the value of this key
                is true, then any collapse blocks in the loaded content will be
                automatically expanded and stripped, and all content in
                collapsible sections will be visible at all times.

            ‘fullWidthPossible’
                Specifies whether full-width elements are permitted in the
                loaded content. Generally true only for the main page load. If
                false, elements marked as full-width will be laid out as if for
                a mobile (narrow) viewport, regardless of the actual dimensions
                of the loaded content’s container (i.e. they will not actually
                be “full-width”).

            ‘localize’
                Specifies whether content should be “localized” to the context
                into which it is being injected. (Affects things like link
                qualification. See transclude.js for more information.)
                Generally true for page content, false for auxiliary content.

            ‘mergeFootnotes’
                Specifies whether footnotes in the content will be merged into
                the page wherein the content is being injected. Inapplicable on
                the initial page load, generally false for auxiliary content;
                generally true for page content, if the ‘localize’ flag is true
                (although false in some cases even then; see, e.g., the
                .include-content-core alias class in transclude.js).
 */

GW.contentLoadHandlers = { };

/*  Add content load handler (i.e., an event handler for the GW.contentDidLoad
    event). (Convenience function.)
 */
function addContentLoadHandler(handler, phase = "", condition = null, once = false) {
    GW.notificationCenter.addHandlerForEvent("GW.contentDidLoad", handler, {
        phase: phase,
        condition: condition,
        once: once
    });
}

GW.contentInjectHandlers = { };

/*  Add content inject handler (i.e., an event handler for the
    GW.contentDidInject event). (Convenience function.)
 */
function addContentInjectHandler(handler, phase = "", condition = null, once = false) {
    GW.notificationCenter.addHandlerForEvent("GW.contentDidInject", handler, {
        phase: phase,
        condition: condition,
        once: once
    });
}

/*  Event-specific handler phase order for the ‘GW.contentDidLoad’ and
    ‘GW.contentDidInject’ events.
 */
GW.notificationCenter.handlerPhaseOrders["GW.contentDidLoad"] = [ "transclude", "rewrite" ];
GW.notificationCenter.handlerPhaseOrders["GW.contentDidInject"] = [ "rewrite", "eventListeners" ];

/*  Event-specific boolean flags for the ‘GW.contentDidInject’ event.
 */
GW.contentDidInjectEventFlags = {
    clickable:          1 << 0,
    stripCollapses:     1 << 1,
    fullWidthPossible:  1 << 2,
    localize:           1 << 3,
    mergeFootnotes:     1 << 4
};

/*  Event-specific pre-fire processing for the ‘GW.contentDidInject’ event.
 */
GW.notificationCenter.prefireProcessors["GW.contentDidInject"] = (eventInfo) => {
    for (let [flagName, flagValue] of Object.entries(GW.contentDidInjectEventFlags))
        eventInfo[flagName] = (0 != (eventInfo.flags & flagValue));

    return eventInfo;
};


/********************/
/* EVENT LISTENERS */
/********************/

GW.eventListeners = { };

/******************************************************************************/
/*  Adds a named event listener to the page (or other target).

    The purpose of this function is to dramatically improve the performance of
    handler code attached to continuous UI events, such as scrolling (i.e., the 
    “scroll” event, attached to any scroll container) or window resizing (i.e., 
    the “resize” event, attached to the `window` object).

    Because such events are fired at a rate independent of the actual current
    animation frame rate, using the usual event listener system to attach 
    handlers to events of this sort causes performance to suffer, as the 
    handler is called much more often than necessary, leading to lag.

    The solution is to add an event listener that fires only once (the next 
    time the event is triggered); waits for the next animation frame; runs the 
    requisite code; then adds itself as an event listener again. This has the
    effect of running the handler code at most once per animation frame, no 
    matter how much more often the event is fired.

    This behavior is abstracted into an API which easily replaces the built-in 
    addEventListener() API.

    Available option fields:

    name (string)
        A string identifier for the event listener being added. If a name is
        provided, then a reference to the event listener is retained, such that
        the listener may later be removed (see the removeNamedEventListener()
        function).

        Provided names must be unique per event. (A listener “foo” for event 
        “bar” attached to object `baz` will overwrite a listener “foo” for 
        event “bar” attached to object `quux`.)

    defer (boolean)
        If set to true, and the page has not yet finished loading, then the 
        provided handler is not added immediately, but only on the next 
        animation frame after the page has finished loading (using the 
        doWhenPageLoaded() function). (If the page *has* finished loading, then
        the handler is added on the immediately next animation frame.)

        (This is useful for code that implements a UI behavior which should not 
         operate prior to the page having loaded and appropriate on-load setup 
         code having run.)

    ifDeferCallWhenAdd (boolean)
        If the `defer` option is enabled (set to true), this option controls 
        whether the provided handler function is called immediately, just prior
        to the event listener being added.

        Essentially, setting this to `true` means that we are assuming that the 
        event in question will have fired at least once between the beginning 
        of the page load process and the deferred moment when we actually add 
        the listener, and thus the handler code should be run.

        NOTE: The invocation of the handler function (fn()) immediately prior 
        to the event listener being added will *not* have any event object 
        passed to it (because it’s not being triggered by a fired event, nor
        called within a listener function that was triggered by a fired event).
        The handler function must be able to handle the case of an undefined
        `event` argument, if this option is used!

        (This option has no effect if the `defer` option is not enabled.)
 */
function addNamedEventListener(target, eventName, fn, options) {
    options = Object.assign({
        name: null,
        defer: false,
        ifDeferCallWhenAdd: false
    }, options);

    if (options.defer) {
        doWhenPageLoaded(() => {
            requestAnimationFrame(() => {
                if (options.ifDeferCallWhenAdd)
                    fn();
                addNamedEventListener(target, eventName, fn, {
                    name: options.name,
                    defer: false
                });
            });
        });

        return;
    }

    let wrapper = (event) => {
        requestAnimationFrame(() => {
            if (wrapper.removed == true)
                return;

            fn(event);
            target.addEventListener(eventName, wrapper, { once: true, passive: true });
        });
    }
    target.addEventListener(eventName, wrapper, { once: true, passive: true });

    /*  Retain a reference to the event listener, if a name is provided.
     */
    if (options.name) {
        if (GW.eventListeners[eventName] == null)
            GW.eventListeners[eventName] = { };

        GW.eventListeners[eventName][options.name] = {
            wrapper: wrapper,
            target: target
        };
    }

    return wrapper;
}

/*  Removes a named event listener from the page (or other target).
 */
function removeNamedEventListener(eventName, name) {
    if (GW.eventListeners[eventName] == null)
        return;

    let listener = GW.eventListeners[eventName][name];
    if (listener) {
        listener.target.removeEventListener(eventName, listener.wrapper);
        listener.wrapper.removed = true;
        GW.eventListeners[eventName][name] = null;
    }
}

/*  Adds a “scroll” event listener to the document (or other target).
 */
function addScrollListener(fn, options) {
    return addNamedEventListener((options.target ?? document), "scroll", fn, options);
}

/*  Removes a named “scroll” event listener from the document (or other 
    target).
 */
function removeScrollListener(name) {
    removeNamedEventListener("scroll", name);
}

/*  Adds a “mousemove” event listener to the window (or other target).
 */
function addMousemoveListener(fn, options) {
    return addNamedEventListener((options.target ?? window), "mousemove", fn, options);
}

/*  Removes a named “mousemove” event listener from the window (or other 
    target).
 */
function removeMousemoveListener(name) {
    removeNamedEventListener("mousemove", name);
}

/*  Adds a “resize” event listener to the window.
 */
function addWindowResizeListener(fn, options) {
    return addNamedEventListener(window, "resize", fn, options);
}

/*  Removes a named “resize” event listener from the window.
 */
function removeWindowResizeListener(name) {
    removeNamedEventListener("resize", name);
}


/****************/
/* SCROLL STATE */
/****************/

GW.scrollState = {
    lastScrollTop:              0,
    unbrokenDownScrollDistance: 0,
    unbrokenUpScrollDistance:   0
};

function updateScrollState(event) {
    GWLog("updateScrollState", "inline.js", 3);

    GW.scrollState.newScrollTop = window.pageYOffset;
    GW.scrollState.unbrokenDownScrollDistance = GW.scrollState.newScrollTop > GW.scrollState.lastScrollTop
                                                ? (  GW.scrollState.unbrokenDownScrollDistance
                                                   + GW.scrollState.newScrollTop
                                                   - GW.scrollState.lastScrollTop)
                                                : 0;
    GW.scrollState.unbrokenUpScrollDistance = GW.scrollState.newScrollTop < GW.scrollState.lastScrollTop
                                              ? (  GW.scrollState.unbrokenUpScrollDistance
                                                 + GW.scrollState.lastScrollTop
                                                 - GW.scrollState.newScrollTop)
                                              : 0;
    GW.scrollState.lastScrollTop = GW.scrollState.newScrollTop;
}
addScrollListener(updateScrollState, {
    name: "updateScrollStateScrollListener",
    defer: true,
    ifDeferCallWhenAdd: true
});

/*  Toggles whether the page is scrollable.
 */
function isPageScrollingEnabled() {
    return !(document.documentElement.classList.contains("scroll-enabled-not"));
}
/*  Pass true or false to enable or disable (respectively) page scrolling.
    Calling this function with no arguments toggles the state (enables if
    currently disabled, or vice versa).
 */
function togglePageScrolling(enable) {
    if (typeof enable == "undefined")
        enable = document.documentElement.classList.contains("scroll-enabled-not");

    let preventScroll = (event) => {
        document.documentElement.scrollTop = GW.scrollState.lastScrollTop;
    };

    /*  The `scroll-enabled-not` CSS class, which is added to the `html` element
        when scrolling is disabled by this function (in order to permit the
        “toggle” behavior, i.e. calling ‘togglePageScrolling’ with no
        arguments), allows the assignment of arbitrary CSS properties to the
        page on the basis of scroll state. This is purely a convenience (which
        may be useful if, for example, some styling needs to change on the basis
        of change in page scroll state, e.g. modifying the appearance of scroll
        bars). No specific CSS properties are needed in order for this function
        to work properly.
     */
    if (   enable
        && isPageScrollingEnabled() == false) {
        document.documentElement.classList.toggle("scroll-enabled-not", false);
        removeScrollListener("preventScroll");
        addScrollListener(updateScrollState, {
            name: "updateScrollStateScrollListener"
        });
    } else if (  !enable
               && isPageScrollingEnabled() == true) {
        document.documentElement.classList.toggle("scroll-enabled-not", true);
        removeScrollListener("updateScrollStateScrollListener");
        addScrollListener(preventScroll, {
            name: "preventScroll"
        });
    }
}


/***********/
/* DO-WHEN */
/***********/

/*  Run the given function immediately if the page is already loaded, or add
    a listener to run it as soon as the page loads.
 */
function doWhenPageLoaded(f) {
    if (document.readyState == "complete")
        f();
    else
        window.addEventListener("load", () => { f(); });
}

/*  Run the given function immediately if the page content has already loaded
    (DOMContentLoaded event has fired), or add a listener to run it as soon as
    the event fires.
 */
function doWhenDOMContentLoaded(f) {
    if (GW.DOMContentLoaded == true)
        f();
    else
        window.addEventListener("DOMContentLoaded", () => { f(); });
}

/*  Run the given function immediately if an element specified by a given
    selector exists; otherwise, add a mutation observer to run the given 
    function as soon as such an element is added to the document.
 */
function doWhenElementExists(f, selector) {
    if (document.querySelector(selector) != null) {
        f();
    } else {
        let observer = new MutationObserver((mutationsList, observer) => {
            if (document.querySelector(selector) != null) {
                observer.disconnect();
                f();
            }
        });

        observer.observe(document.documentElement, { childList: true, subtree: true });
    }
}

/*  Run the given function immediately if the <body> element has already been
    created, or add a mutation observer to run it as soon as the <body> element
    is created.
 */
function doWhenBodyExists(f) {
    doWhenElementExists(f, "body");
}

/*  Run the given function immediately if the <main> element has already been
    created, or add a mutation observer to run it as soon as the <main> element
    is created.
 */
function doWhenMainExists(f) {
    doWhenElementExists(f, "main");
}

/*  Define convenient alias.
 */
doWhenMainExists(() => {
    document.main = document.querySelector("main");
});


/******************/
/* BROWSER EVENTS */
/******************/

/*  We know this is false here, because this script is loaded synchronously 
    from a <script> element in the <head> of the page; so the page body has not 
    yet loaded when this code runs.
 */
GW.DOMContentLoaded = false;

GWLog("document.readyState." + document.readyState, "browser event");
window.addEventListener("DOMContentLoaded", () => {
    GWLog("window.DOMContentLoaded", "browser event");
    GW.DOMContentLoaded = true;
    let pageURL = URLFromString(location.href);
    GW.notificationCenter.fireEvent("GW.contentDidLoad", {
        source: "DOMContentLoaded",
        container: document.main,
        document: document,
        loadLocation: pageURL
    });
    GW.notificationCenter.fireEvent("GW.contentDidInject", {
        source: "DOMContentLoaded",
        container: document.main,
        document: document,
        loadLocation: pageURL,
        flags: (  GW.contentDidInjectEventFlags.clickable
                | GW.contentDidInjectEventFlags.fullWidthPossible
                | GW.contentDidInjectEventFlags.localize)
    });
});
window.addEventListener("load", () => {
    GWLog("window.load", "browser event");
});
document.addEventListener("readystatechange", () => {
    GWLog("document.readyState." + document.readyState, "browser event");
});

/*******************/
/*  UTILITY        .
/*                  */

/*****************************************************************************/
/*	Returns a URL constructed from either a fully qualified URL string,
	or an absolute local URL (pathname starting at root), or a relative URL
	(pathname component replacing part of current URL after last slash), or
	a hash (URL fragment) only.

	(The existing URL() constructor only handles fully qualified URL strings.)

	The optional baseURL argument allows for qualifying non-fully-qualified
	URL strings relative to a base URL other than the current page location.
 */
function URLFromString(urlString, baseURL = location) {
	if (   urlString.startsWith("http://")
		|| urlString.startsWith("https://"))
		return new URL(urlString);

	if (urlString.startsWith("#"))
		return new URL(baseURL.origin + baseURL.pathname + urlString);

	return (urlString.startsWith("/")
			? new URL(baseURL.origin + urlString)
			: new URL(baseURL.href.replace(/[^\/]*$/, urlString)));
}

/****************************************************************************/
/*	Returns a modified URL constructed from the given URL or URL string, with
	the specified modifications in key-value form.
 */
function modifiedURL(url, mods) {
	let modURL = typeof url == "string" 
				 ? URLFromString(url) 
				 : URLFromString(url.href);
	for (let [ key, value ] of Object.entries(mods))
		modURL[key] = value;
	return modURL;
}

/***************************************************************************/
/*	Returns the value of the search param with the given key for a the given
	HTMLAnchorElement object.
 */
HTMLAnchorElement.prototype.getQueryVariable = function (key) {
	let url = URLFromString(this.href);
	return url.searchParams.get(key);
}

/**************************************************************************/
/*	Set a URL search parameter with the given key to the given value on the
	given HTMLAnchorElement.
 */
HTMLAnchorElement.prototype.setQueryVariable = function (key, value) {
	let url = URLFromString(this.href);
	url.setQueryVariable(key, value);
	this.search = url.search;
}

/******************************************************************/
/*	Delete a URL search parameter with the given key from the given 
	HTMLAnchorElement.
 */
HTMLAnchorElement.prototype.deleteQueryVariable = function (key) {
	let url = URLFromString(this.href);
	url.deleteQueryVariable(key);
	this.search = url.search;
}

/**************************************************************************/
/*  Call the given function when the given element intersects the viewport.

	The `entries` parameter of the IntersectionObserver callback is passed
	to the called function (unless called immediately).

    Available option fields:

	root
		See IntersectionObserver documentation.

	threshold
		See IntersectionObserver documentation.

	rootMargin
		See IntersectionObserver documentation.
 */
function lazyLoadObserver(f, target, options) {
	options = Object.assign({ }, options);

    if (target == null)
        return;

	requestAnimationFrame(() => {
		if (   (options.threshold ?? 0) == 0
			&& (options.rootMargin ?? "0px").includes("-") == false
			&& isWithinRectOf(target, options.root)) {
			f();
			return;
		}

		let observer = new IntersectionObserver((entries) => {
			if (entries.first.isIntersecting == false)
				return;

			f(entries);
			observer.disconnect();
		}, options);

		observer.observe(target);
	});
}

/***********************************************************************/
/*  Call the given function when the given element is resized.

	The `entries` parameter of the ResizeObserver callback is passed
	to the called function.

	If `false` is returned from the function call, disconnects observer.
	Otherwise, continues observation.
 */
function resizeObserver(f, target) {
	if (target == null)
		return;

	requestAnimationFrame(() => {
		let observer = new ResizeObserver((entries) => {
			if (f(entries) == false)
				observer.disconnect();
		});

		observer.observe(target);
	});
}


/*	sidenotes.js: standalone JS library for parsing HTML documents with
	Pandoc-style footnotes and dynamically repositioning them into the
	left/right margins, when browser windows are wide enough.

	Sidenotes (see https://gwern.net/sidenote ) are superior to footnotes where
	possible because they enable the reader to immediately look at them without
	requiring user action to â€œgo toâ€ or â€œpop upâ€ the footnotes; even floating
	footnotes require effort by the reader.

	sidenotes.js is inspired by the Tufte-CSS sidenotes
	(https://edwardtufte.github.io/tufte-css/#sidenotes), but where Tufte-CSS
	uses static footnotes inlined into the body of the page (requiring
	modifications to Pandocâ€™s compilation), which doesnâ€™t always work well for
	particularly long or frequent sidenotes, sidenotes.js will rearrange
	sidenotes to fit as best as possible, and will respond to window changes.

	Particularly long sidenotes are also partially â€œcollapsedâ€. Styling
	(especially for oversized-sidenotes which must scroll) is done in
	/static/css/default.css â€œSIDENOTESâ€ section.

	Author: Said Achmiz
	2019-03-11
	license: MIT (derivative of footnotes.js, which is PD)
 */

/*****************/
/*	Configuration.
 */
Sidenotes = {
	/*  The `sidenoteSpacing` constant defines the minimum vertical space that
		is permitted between adjacent sidenotes; any less, and they are
		considered to be overlapping.
	 */
	sidenoteSpacing: 60.0,

	/*	This includes the border width.
	 */
	sidenotePadding: 13.0,

	/*	Elements which occupy (partially or fully) the sidenote columns, and
		which can thus collide with sidenotes.
	 */
	potentiallyOverlappingElementsSelectors: [
		".width-full img",
		".width-full video",
		".width-full .caption-wrapper",
		".width-full table",
		".width-full pre",
		".marginnote"
	],

	constrainMarginNotesWithinSelectors: [
		".backlink-context",
		".margin-notes-block"
	],

	/*	The smallest width (in CSS dimensions) at which sidenotes will be shown.
		If the viewport is narrower than this, then sidenotes are disabled.
	 */
	minimumViewportWidthForSidenotes: "1761px",

	useLeftColumn: () => false,
	useRightColumn: () => true
};

/******************/
/*	Implementation.
 */
Sidenotes = { ...Sidenotes,
	/*  Media query objects (for checking and attaching listeners).
	 */
	mediaQueries: {
		viewportWidthBreakpoint: matchMedia(`(min-width: ${Sidenotes.minimumViewportWidthForSidenotes})`)
	},

	/*****************/
	/* Infrastructure.
	 */
	sidenotes: null,
	citations: null,

	sidenoteColumnLeft: null,
	sidenoteColumnRight: null,

	hiddenSidenoteStorage: null,

	positionUpdateQueued: false,

	sidenoteOfNumber: (number) => {
		return (Sidenotes.sidenotes.find(sidenote => Notes.noteNumberFromHash(sidenote.id) == number) ?? null);
	},

	citationOfNumber: (number) => {
		return (Sidenotes.citations.find(citation => Notes.noteNumberFromHash(citation.id) == number) ?? null);
	},

	/*	The sidenote of the same number as the given citation;
		or, the citation of the same number as the given sidenote.
	 */
	counterpart: (element) => {
		let number = Notes.noteNumberFromHash(element.id);
		let counterpart = (element.classList.contains("sidenote")
						   ? Sidenotes.citationOfNumber(number)
						   : Sidenotes.sidenoteOfNumber(number));
		if (counterpart == null)
			GWLog(`Counterpart of ${element.tagName}#${element.id}.${(Array.from(element.classList).join("."))} not found!`, "sidenotes.js", 0);
		return counterpart;
	},

	/*  The â€œtarget counterpartâ€ is the element associated with the target, i.e.:
		if the URL hash targets a footnote reference, its counterpart is the
		sidenote for that citation; and vice-versa, if the hash targets a sidenote,
		its counterpart is the in-text citation. We want a target counterpart to be
		highlighted along with the target itself; therefore we apply a special
		â€˜targetedâ€™ class to the target counterpart.
	 */
	updateTargetCounterpart: () => {
		GWLog("Sidenotes.updateTargetCounterpart", "sidenotes.js", 1);

		if (Sidenotes.mediaQueries.viewportWidthBreakpoint.matches == false)
			return;

		//  Clear existing targeting.
		let targetedElementSelector = [
			".footnote-ref",
			".footnote",
			".sidenote"
		].map(x => x + ".targeted").join(", ");
		document.querySelectorAll(targetedElementSelector).forEach(element => {
			element.classList.remove("targeted");
		});

		//  Identify target and counterpart, if any.
		let target = location.hash.match(/^#(sn|fnref)[0-9]+$/)
					 ? getHashTargetedElement()
					 : null;

		if (target == null)
			return;

		let counterpart = Sidenotes.counterpart(target);

		//  Mark the target and the counterpart, if any.
		if (target)
			target.classList.add("targeted");
		if (counterpart)
			counterpart.classList.add("targeted");
	},

	/*  Hide sidenotes within currently-collapsed collapse blocks. Show
		sidenotes not within currently-collapsed collapse blocks.
	 */
	updateSidenotesInCollapseBlocks: () => {
		GWLog("Sidenotes.updateSidenotesInCollapseBlocks", "sidenotes.js", 1);

		Sidenotes.sidenotes.forEach(sidenote => {
			let citation = Sidenotes.counterpart(sidenote);
			sidenote.classList.toggle("hidden", isWithinCollapsedBlock(citation));
		});
	},

	/*	Queues a sidenote position update on the next available animation frame,
		if an update is not already queued.
	 */
	updateSidenotePositionsIfNeeded: () => {
		if (Sidenotes.positionUpdateQueued)
			return;

		Sidenotes.positionUpdateQueued = true;
		requestAnimationFrame(() => {
			Sidenotes.positionUpdateQueued = false;
			Sidenotes.updateSidenotePositions();
		});
	},

	/*  This function actually calculates and sets the positions of all sidenotes.
	 */
	updateSidenotePositions: () => {
		GWLog("Sidenotes.updateSidenotePositions", "sidenotes.js", 1);

		/*  If weâ€™re in footnotes mode (ie. the viewport is too narrow), then
			donâ€™t do anything.
		 */
		if (Sidenotes.mediaQueries.viewportWidthBreakpoint.matches == false)
			return;

		//  Update the disposition of sidenotes within collapse blocks.
		Sidenotes.updateSidenotesInCollapseBlocks();

		//	Check for cut-off sidenotes.
		Sidenotes.sidenotes.forEach(sidenote => {
			/*  Check whether the sidenote is currently hidden (i.e., within a
				currently-collapsed collapse block or similar). If so, skip it.
			 */
			if (sidenote.classList.contains("hidden")) {
				Sidenotes.hiddenSidenoteStorage.append(sidenote);
				return;
			}

			//  On which side should the sidenote go?
			let sidenoteNumber = Notes.noteNumberFromHash(sidenote.id);
			let side = null;
			       if (   Sidenotes.useLeftColumn()  == true
					   && Sidenotes.useRightColumn() == false) {
				//	Left.
				side = Sidenotes.sidenoteColumnLeft;
			} else if (   Sidenotes.useLeftColumn()  == false
					   && Sidenotes.useRightColumn() == true) {
				//	Right.
				side = Sidenotes.sidenoteColumnRight;
			} else if (   Sidenotes.useLeftColumn()  == true
					   && Sidenotes.useRightColumn() == true) {
				//	Odd - right; even - left.
				side = (sidenoteNumber % 2
						? Sidenotes.sidenoteColumnLeft
						: Sidenotes.sidenoteColumnRight);
			}

			//  Inject the sidenote into the column (provisionally).
			side.append(sidenote);

			/*  Mark sidenotes which are cut off vertically.
			 */
			let sidenoteOuterWrapper = sidenote.firstElementChild;
			sidenote.classList.toggle("cut-off", (sidenoteOuterWrapper.scrollHeight > sidenoteOuterWrapper.offsetHeight + 2));
		});

		/*  Determine proscribed vertical ranges (ie. bands of the page from which
			sidenotes are excluded, by the presence of, eg. a full-width table).
		 */
		let leftColumnBoundingRect = Sidenotes.sidenoteColumnLeft.getBoundingClientRect();
		let rightColumnBoundingRect = Sidenotes.sidenoteColumnRight.getBoundingClientRect();

		/*  Examine all potentially overlapping elements (ie. non-sidenote
			elements that may appear in, or extend into, the side columns).
		 */
		let proscribedVerticalRangesLeft = [ ];
		let proscribedVerticalRangesRight = [ ];
		document.querySelectorAll(Sidenotes.potentiallyOverlappingElementsSelectors.join(", ")).forEach(potentiallyOverlappingElement => {
			if (isWithinCollapsedBlock(potentiallyOverlappingElement))
				return;

			let elementBoundingRect = potentiallyOverlappingElement.getBoundingClientRect();

			if (!(   elementBoundingRect.left > leftColumnBoundingRect.right
				  || elementBoundingRect.right < leftColumnBoundingRect.left))
				proscribedVerticalRangesLeft.push({ top: (elementBoundingRect.top - Sidenotes.sidenoteSpacing) - leftColumnBoundingRect.top,
													bottom: (elementBoundingRect.bottom + Sidenotes.sidenoteSpacing) - leftColumnBoundingRect.top,
													element: potentiallyOverlappingElement });

			if (!(   elementBoundingRect.left > rightColumnBoundingRect.right
				  || elementBoundingRect.right < rightColumnBoundingRect.left))
				proscribedVerticalRangesRight.push({ top: (elementBoundingRect.top - Sidenotes.sidenoteSpacing) - rightColumnBoundingRect.top,
													 bottom: (elementBoundingRect.bottom + Sidenotes.sidenoteSpacing) - rightColumnBoundingRect.top,
													 element: potentiallyOverlappingElement });
		});

		//  The bottom edges of each column are also â€œproscribed vertical rangesâ€.
		proscribedVerticalRangesLeft.push({
			top:    Sidenotes.sidenoteColumnLeft.clientHeight,
			bottom: Sidenotes.sidenoteColumnLeft.clientHeight
		});
		proscribedVerticalRangesRight.push({
			top:    Sidenotes.sidenoteColumnRight.clientHeight,
			bottom: Sidenotes.sidenoteColumnRight.clientHeight
		});

		//	Sort and merge.
		[ proscribedVerticalRangesLeft, proscribedVerticalRangesRight ].forEach(ranges => {
			ranges.sort((rangeA, rangeB) => {
				return (rangeA.top - rangeB.top);
			});

			for (let i = 0; i < ranges.length - 1; i++) {
				let thisRange = ranges[i];
				let nextRange = ranges[i + 1];

				if (nextRange.top <= thisRange.bottom) {
					thisRange.bottom = nextRange.bottom;
					ranges.splice(i + 1, 1);
					i++;
				}
			}
		});

		/*	Remove sidenotes from page, so that we can set their positions
			without causing reflow. Store their layout heights (which cannot
			be retrieved in the normal way while the sidenotes arenâ€™t part of
			the DOM).
		 */
		Sidenotes.sidenotes.forEach(sidenote => {
			sidenote.lastKnownHeight = sidenote.offsetHeight;
			sidenote.remove();
		});

		//	Clean up old layout cells, if any.
		[ Sidenotes.sidenoteColumnLeft, Sidenotes.sidenoteColumnRight ].forEach(column => {
			column.querySelectorAll(".sidenote-layout-cell").forEach(cell => cell.remove());
		});

		//	Construct new layout cells.
		let layoutCells = [ ];
		let sides = [ ];
		if (Sidenotes.useLeftColumn())
			sides.push([ Sidenotes.sidenoteColumnLeft, leftColumnBoundingRect, proscribedVerticalRangesLeft ]);
		if (Sidenotes.useRightColumn())
			sides.push([ Sidenotes.sidenoteColumnRight, rightColumnBoundingRect, proscribedVerticalRangesRight ]);
		sides.forEach(side => {
			let [ column, rect, ranges ] = side;
			let prevRangeBottom = 0;

			ranges.forEach(range => {
				let cell = newElement("DIV", {
					"class": "sidenote-layout-cell"
				}, {
					"sidenotes": [ ],
					"container": column,
					"room": (range.top - prevRangeBottom),
					"style": `top: ${prevRangeBottom + "px"}; height: ${(range.top - prevRangeBottom) + "px"}`
				});

				column.append(cell);
				cell.rect = cell.getBoundingClientRect();
				layoutCells.push(cell);

				prevRangeBottom = range.bottom;
			});
		});

		/*	Default position for a sidenote within a layout cell is vertically
			aligned with the footnote reference, or else at the top of the
			cell, whichever is lower.
		 */
		let defaultNotePosInCellForCitation = (cell, citation) => {
			return Math.max(0, Math.round((citation.getBoundingClientRect().top - cell.rect.top) + 4));
		};

		//	Assign sidenotes to layout cells.
		for (citation of Sidenotes.citations) {
			let citationBoundingRect = citation.getBoundingClientRect();

			let sidenote = Sidenotes.counterpart(citation);

			/*  Is this sidenote even displayed? Or is it hidden (i.e., its
				citation is within a currently-collapsed collapse block)? If so,
				skip it.
			 */
			if (sidenote.classList.contains("hidden")) {
				Sidenotes.hiddenSidenoteStorage.append(sidenote);
				continue;
			}

			//	Get all the cells that the sidenote can fit into.
			let fittingLayoutCells = layoutCells.filter(cell => cell.room >= sidenote.lastKnownHeight);
			if (fittingLayoutCells.length == 0) {
				GWLog("TOO MUCH SIDENOTES. GIVING UP. :(", "sidenotes.js");
				Sidenotes.sidenotes.forEach(sidenote => {
					sidenote.remove();
				});
				return;
			}

			/*	These functions are used to sort layout cells by best fit for
				placing the current sidenote.
			 */
			let vDistanceToCell = (cell) => {
				if (   citationBoundingRect.top > cell.rect.top
					&& citationBoundingRect.top < cell.rect.bottom)
					return 0;
				return (citationBoundingRect.top < cell.rect.top
						? Math.abs(citationBoundingRect.top - cell.rect.top)
						: Math.abs(citationBoundingRect.top - cell.rect.bottom));
			};
			let hDistanceToCell = (cell) => {
				return Math.abs(citationBoundingRect.left - (cell.left + (cell.width / 2)));
			};
			let overlapWithNote = (cell, note) => {
				let notePosInCell = defaultNotePosInCellForCitation(cell, citation);

				let otherNoteCitation = Sidenotes.counterpart(note);
				let otherNotePosInCell = defaultNotePosInCellForCitation(cell, otherNoteCitation);

				return (   otherNotePosInCell > notePosInCell + sidenote.lastKnownHeight + Sidenotes.sidenoteSpacing
						|| notePosInCell      > otherNotePosInCell + note.lastKnownHeight + Sidenotes.sidenoteSpacing)
					   ? 0
					   : Math.max(notePosInCell + sidenote.lastKnownHeight + Sidenotes.sidenoteSpacing - otherNotePosInCell,
					   			  otherNotePosInCell + note.lastKnownHeight + Sidenotes.sidenoteSpacing - notePosInCell);
			};
			let cellCrowdedness = (cell) => {
				return cell.sidenotes.reduce((totalOverlap, note) => { return (totalOverlap + overlapWithNote(cell, note)); }, 0);
			};

			/*	We sort the fitting cells by vertical distance from the sidenote
				and crowdedness at the sidenoteâ€™s default location within the
				cell, and secondarily by horizontal distance from the sidenote.
			 */
			fittingLayoutCells.sort((cellA, cellB) => {
				return (   (  (vDistanceToCell(cellA) + cellCrowdedness(cellA))
							- (vDistanceToCell(cellB) + cellCrowdedness(cellB)))
						|| (hDistanceToCell(cellA) - hDistanceToCell(cellB)));
			});
			let closestFittingLayoutCell = fittingLayoutCells[0];

			//	Add the sidenote to the selected cell.
			closestFittingLayoutCell.room -= (sidenote.lastKnownHeight + Sidenotes.sidenoteSpacing);
			closestFittingLayoutCell.sidenotes.push(sidenote);
		};

		//	Function to compute distance between two successive sidenotes.
		let getDistance = (noteA, noteB) => {
			return (noteB.posInCell - (noteA.posInCell + noteA.lastKnownHeight + Sidenotes.sidenoteSpacing));
		};

		//	Position sidenotes within layout cells.
		layoutCells.forEach(cell => {
			if (cell.sidenotes.length == 0)
				return;

			//	Set all of the cellâ€™s sidenotes to default positions.
			cell.sidenotes.forEach(sidenote => {
				let citation = Sidenotes.counterpart(sidenote);
				sidenote.posInCell = defaultNotePosInCellForCitation(cell, citation);
			});

			//	Sort the cellâ€™s sidenotes vertically (secondarily by number).
			cell.sidenotes.sort((noteA, noteB) => {
				return (   (noteA.posInCell - noteB.posInCell)
						|| (parseInt(noteA.id.substr(2)) - parseInt(noteB.id.substr(2))));
			});

			//	Called in pushNotesUp().
			let shiftNotesUp = (noteIndexes, shiftUpDistance) => {
				noteIndexes.forEach(idx => {
					cell.sidenotes[idx].posInCell -= shiftUpDistance;
				});
			};

			//	Called immediately below.
			let pushNotesUp = (pushUpWhich, pushUpForce, bruteStrength = false) => {
				let roomToPush = pushUpWhich.first == 0
								 ? cell.sidenotes[pushUpWhich.first].posInCell
								 : Math.max(0, getDistance(cell.sidenotes[pushUpWhich.first - 1], cell.sidenotes[pushUpWhich.first]));

				let pushUpDistance = bruteStrength
									 ? pushUpForce
									 : Math.floor(pushUpForce / pushUpWhich.length);
				if (pushUpDistance <= roomToPush) {
					shiftNotesUp(pushUpWhich, pushUpDistance);
					return (pushUpForce - pushUpDistance);
				} else {
					shiftNotesUp(pushUpWhich, roomToPush);
					if (pushUpWhich.first == 0)
						return (pushUpForce - roomToPush);

					pushUpWhich.splice(0, 0, pushUpWhich.first - 1);
					return pushNotesUp(pushUpWhich, (pushUpForce - roomToPush), bruteStrength);
				}
			};

			/*	Check each sidenote after the first for overlap with the one
				above it; if it overlaps, try pushing the sidenote(s) above it
				upward, and also shift the note itself downward.
			 */
			for (let i = 1; i < cell.sidenotes.length; i++) {
				let prevNote = cell.sidenotes[i - 1];
				let thisNote = cell.sidenotes[i];
				let nextNote = (i == cell.sidenotes.length - 1)
							   ? null
							   : cell.sidenotes[i + 1];

				let overlapAbove = Math.max(0, (-1 * getDistance(prevNote, thisNote)));
				if (overlapAbove == 0)
					continue;

				let pushUpForce = Math.round(overlapAbove / 2);
				thisNote.posInCell += ((overlapAbove - pushUpForce) + pushNotesUp([ (i - 1) ], pushUpForce));
			}

			/*	Check whether the lowest sidenote overlaps the cellâ€™s bottom;
				if so, push it (and any sidenotes above it that it bumps into)
				upward.
			 */
			let overlapOfBottom = Math.max(0, (cell.sidenotes.last.posInCell + cell.sidenotes.last.lastKnownHeight) - parseInt(cell.style.height));
			if (overlapOfBottom > 0)
				pushNotesUp([ (cell.sidenotes.length - 1) ], overlapOfBottom, true);

			//	Set the sidenote positions via inline styles.
			cell.sidenotes.forEach(sidenote => {
				sidenote.style.top = Math.round(sidenote.posInCell) + "px";
			});

			//	Re-inject the sidenotes into the page.
			cell.append(...cell.sidenotes);
		});

		//  Un-hide the sidenote columns.
		Sidenotes.sidenoteColumnLeft.style.visibility = "";
		Sidenotes.sidenoteColumnRight.style.visibility = "";

		//	Fire event.
		GW.notificationCenter.fireEvent("Sidenotes.sidenotePositionsDidUpdate");
	},

	/*  Destroys the HTML structure of the sidenotes.
	 */
	deconstructSidenotes: () => {
		GWLog("Sidenotes.deconstructSidenotes", "sidenotes.js", 1);

		Sidenotes.sidenotes = null;
		Sidenotes.citations = null;

		if (Sidenotes.sidenoteColumnLeft)
			Sidenotes.sidenoteColumnLeft.remove();
		Sidenotes.sidenoteColumnLeft = null;

		if (Sidenotes.sidenoteColumnRight)
			Sidenotes.sidenoteColumnRight.remove();
		Sidenotes.sidenoteColumnRight = null;

		if (Sidenotes.hiddenSidenoteStorage)
			Sidenotes.hiddenSidenoteStorage.remove();
		Sidenotes.hiddenSidenoteStorage = null;
	},

	/*  Constructs the HTML structure, and associated listeners and auxiliaries,
		of the sidenotes.
	 */
	constructSidenotes: () => {
		GWLog("Sidenotes.constructSidenotes", "sidenotes.js", 1);

		/*  Do nothing if constructSidenotes() somehow gets run extremely early
			in the page load process.
		 */
		let markdownBody = document.querySelector("#markdownBody");
		if (markdownBody == null)
			return;

		//	Destroy before creating.
		Sidenotes.deconstructSidenotes();

		//  Add the sidenote columns.
		Sidenotes.sidenoteColumnLeft = newElement("DIV", { "id": "sidenote-column-left" });
		Sidenotes.sidenoteColumnRight = newElement("DIV", { "id": "sidenote-column-right" });
		[ Sidenotes.sidenoteColumnLeft, Sidenotes.sidenoteColumnRight ].forEach(column => {
			column.classList.add("footnotes");
			column.style.visibility = "hidden";
			markdownBody.append(column);
		});

		//	Add the hidden sidenote storage.
		markdownBody.append(Sidenotes.hiddenSidenoteStorage = newElement("DIV", {
			"id": "hidden-sidenote-storage",
			"class": "footnotes",
			"style": "display:none"
		}));

		/*  Create and inject the sidenotes.
		 */
		Sidenotes.sidenotes = [ ];
		//  The footnote references (citations).
		Sidenotes.citations = Array.from(document.querySelectorAll("a.footnote-ref"));

		//	If there are no footnotes, weâ€™re done.
		if (Sidenotes.citations.length == 0)
			return;

		Sidenotes.citations.forEach(citation => {
			let noteNumber = Notes.noteNumberFromHash(citation.hash);

			//  Create the sidenote outer containing block...
			let sidenote = newElement("DIV", { class: "sidenote", id: `sn${noteNumber}` });

			/*	Fill the sidenote either by copying from an existing footnote
				in the current page, or else by transcluding the footnote to
				which the citation refers.
			 */
			let referencedFootnote = document.querySelector(`#fn${noteNumber}`);
			let sidenoteContents = newDocument(referencedFootnote
											   ? referencedFootnote.childNodes
											   : synthesizeIncludeLink(citation, {
											   		"class": "include-strict include-unwrap",
											   		"data-include-selector-not": ".footnote-self-link"
											   	 }));

			/*	If the sidenote contents were copied from a footnote that exists
				in the page, then we should regenerate placeholders, otherwise
				the back-to-citation links (among possibly other things) may
				not work right.
			 */
			if (referencedFootnote)
				regeneratePlaceholderIds(sidenoteContents);

			//  Wrap the contents of the footnote in two wrapper divs...
			sidenote.appendChild(sidenote.outerWrapper = newElement("DIV", {
				class: "sidenote-outer-wrapper"
			})).appendChild(sidenote.innerWrapper = newElement("DIV", {
				class: "sidenote-inner-wrapper"
			})).append(sidenoteContents);

			/*  Create & inject the sidenote self-links (ie. boxed sidenote
				numbers).
			 */
			sidenote.append(newElement("A", {
				"class": "sidenote-self-link",
				"href": `#sn${noteNumber}`
			}, {
				"textContent": noteNumber
			}));

			//	Remove footnote self-link.
			sidenote.querySelector(".footnote-self-link")?.remove();

			//	Add listener to update sidenote positions when media loads.
			sidenote.querySelectorAll("figure img, figure video").forEach(mediaElement => {
				mediaElement.addEventListener("load", (event) => {
					Sidenotes.updateSidenotePositionsIfNeeded();
				}, { once: true });
			});

			//  Add the sidenote to the sidenotes array...
			Sidenotes.sidenotes.push(sidenote);

			//	Inject the sidenote into the page.
			Sidenotes.hiddenSidenoteStorage.append(sidenote);
		});

		/*  Bind sidenote mouse-hover events.
		 */
		Sidenotes.citations.forEach(citation => {
			let sidenote = Sidenotes.counterpart(citation);

			//	Unbind existing events, if any.
			if (sidenote.onSidenoteMouseEnterHighlightCitation)
				sidenote.removeEventListener("mouseenter", sidenote.onSidenoteMouseEnterHighlightCitation);
			if (sidenote.onSidenoteMouseLeaveUnhighlightCitation)
				sidenote.removeEventListener("mouseleave", sidenote.onSidenoteMouseLeaveUnhighlightCitation);

			if (citation.onCitationMouseEnterSlideSidenote)
				citation.removeEventListener("mouseenter", citation.onCitationMouseEnterSlideSidenote);
			if (sidenote.onSidenoteMouseEnterSlideSidenote)
				sidenote.removeEventListener("mouseenter", sidenote.onSidenoteMouseEnterSlideSidenote);
			if (sidenote.onSidenoteMouseLeaveUnslideSidenote)
				sidenote.removeEventListener("mouseleave", sidenote.onSidenoteMouseLeaveUnslideSidenote);

			if (sidenote.scrollListener)
				sidenote.outerWrapper.removeEventListener("scroll", sidenote.scrollListener);

			//	Bind new events.
			sidenote.addEventListener("mouseenter", sidenote.onSidenoteMouseEnterHighlightCitation = (event) => {
				citation.classList.toggle("highlighted", true);
			});
			sidenote.addEventListener("mouseleave", sidenote.onSidenoteMouseLeaveUnhighlightCitation = (event) => {
				citation.classList.toggle("highlighted", false);
			});

			citation.addEventListener("mouseenter", citation.onCitationMouseEnterSlideSidenote = (event) => {
				Sidenotes.putAllSidenotesBack(sidenote);
				requestAnimationFrame(() => {
					Sidenotes.slideSidenoteIntoView(sidenote, true);
				});
			});
			sidenote.addEventListener("mouseenter", sidenote.onSidenoteMouseEnterSlideSidenote = (event) => {
				Sidenotes.putAllSidenotesBack(sidenote);
				requestAnimationFrame(() => {
					Sidenotes.slideSidenoteIntoView(sidenote, false);
				});
			});
			sidenote.addEventListener("mouseleave", sidenote.onSidenoteMouseLeaveUnslideSidenote = (event) => {
				Sidenotes.putSidenoteBack(sidenote);
			});

			sidenote.scrollListener = addScrollListener(sidenote.onSidenoteScrollToggleHideMoreIndicator = (event) => {
				sidenote.classList.toggle("hide-more-indicator", sidenote.outerWrapper.scrollTop + sidenote.outerWrapper.clientHeight == sidenote.outerWrapper.scrollHeight);
			}, {
				target: sidenote.outerWrapper
			});
		});

		GW.notificationCenter.fireEvent("Sidenotes.sidenotesDidConstruct");

		//	Fire event.
		GW.notificationCenter.fireEvent("GW.contentDidInject", {
			source: "Sidenotes.constructSidenotes",
			container: Sidenotes.hiddenSidenoteStorage,
			document: document,
			loadLocation: location,
			flags: (  GW.contentDidInjectEventFlags.fullWidthPossible
					| GW.contentDidInjectEventFlags.localize)
		});
	},

	cleanup: () => {
		GWLog("Sidenotes.cleanup", "sidenotes.js", 1);

		/*	Deactivate active media queries.
		 */
		cancelDoWhenMatchMedia("Sidenotes.rewriteHashForCurrentMode");
		cancelDoWhenMatchMedia("Sidenotes.rewriteCitationTargetsForCurrentMode");
		cancelDoWhenMatchMedia("Sidenotes.addOrRemoveEventHandlersForCurrentMode");

		/*	Remove sidenotes & auxiliaries from HTML.
		 */
		Sidenotes.deconstructSidenotes();

		GW.notificationCenter.fireEvent("Sidenotes.cleanupDidComplete");
	},

	/*  Q:  Why is this setup function so long and complex?
		A:  In order to properly handle all of the following:

		1.  The two different modes (footnote popups vs. sidenotes)
		2.  The interactions between sidenotes and collapse blocks
		3.  Linking to footnotes/sidenotes
		4.  Loading a URL that links to a footnote/sidenote
		5.  Changes in the viewport width dynamically altering all of the above

		â€¦ and, of course, correct layout of the sidenotes, even in tricky cases
		where the citations are densely packed and the sidenotes are long.
	 */
	setup: () => {
		GWLog("Sidenotes.setup", "sidenotes.js", 1);

		/*  If the page was loaded with a hash that points to a footnote, but
			sidenotes are enabled (or vice-versa), rewrite the hash in
			accordance with the current mode (this will also cause the page to
			end up scrolled to the appropriate element - footnote or sidenote).
			Add an active media query to rewrite the hash whenever the viewport
			width media query changes.
		 */
		doWhenMatchMedia(Sidenotes.mediaQueries.viewportWidthBreakpoint, "Sidenotes.rewriteHashForCurrentMode", (mediaQuery) => {
			let regex = new RegExp(mediaQuery.matches ? "^#fn[0-9]+$" : "^#sn[0-9]+$");
			let prefix = (mediaQuery.matches ? "#sn" : "#fn");

			if (location.hash.match(regex)) {
				relocate(prefix + Notes.noteNumberFromHash());

				//	Update targeting.
				if (mediaQuery.matches)
					Sidenotes.updateTargetCounterpart();
				else
					updateFootnoteTargeting();
			}
		}, null, (mediaQuery) => {
			if (location.hash.match(/^#sn[0-9]/)) {
				relocate("#fn" + Notes.noteNumberFromHash());

				//	Update targeting.
				updateFootnoteTargeting();
			}
		});

		/*	We do not bother to construct sidenotes on mobile clients, and so
			the rest of this is also irrelevant.
		 */
		if (GW.isMobile())
			return;

		/*	Add event handler to update margin note style in transcluded content
			and pop-frames.
		 */
		addContentInjectHandler(GW.contentInjectHandlers.setMarginNoteStyle = (eventInfo) => {
			GWLog("setMarginNoteStyle", "sidenotes.js", 1);

			/*	Set margin notes to â€˜inlineâ€™ or â€˜sidenoteâ€™ style, depending on 
				what mode the page is in (based on viewport width), whether each
				margin note is in a constrained block, and whether itâ€™s on the 
				main page or in something like a pop-frame.
			 */
			eventInfo.container.querySelectorAll(".marginnote").forEach(marginNote => {
				let inline = (   marginNote.closest(Sidenotes.constrainMarginNotesWithinSelectors.join(", "))
							  || Sidenotes.mediaQueries.viewportWidthBreakpoint.matches == false
							  || eventInfo.document != document);
				marginNote.swapClasses([ "inline", "sidenote" ], (inline ? 0 : 1));
			});
		}, ">rewrite");

		/*	When the main content loads, update the margin note style; and add 
			event listener to re-update it when the viewport width changes.
		 */
		addContentLoadHandler((info) => {
			doWhenMatchMedia(Sidenotes.mediaQueries.viewportWidthBreakpoint, "Sidenotes.updateMarginNoteStyleForCurrentMode", (mediaQuery) => {
				GW.contentInjectHandlers.setMarginNoteStyle(info);
			});
		}, "rewrite", (info) => info.container == document.main, true);

		/*	When an anchor link is clicked that sets the hash to its existing
			value, weird things happen. In particular, weird things happen with
			citations and sidenotes. We must prevent that, by updating state
			properly when that happens. (No â€˜hashchangeâ€™ event is fired in this
			case, so we cannot depend on the â€˜GW.hashDidChangeâ€™ event handler.)
		 */
		addContentInjectHandler(Sidenotes.addFauxHashChangeEventsToNoteMetaLinks = (eventInfo) => {
			let selector = [
				"a.footnote-ref",
				"a.sidenote-self-link",
				".sidenote a.footnote-back"
			].join(", ");

			eventInfo.container.querySelectorAll(selector).forEach(link => {
				link.addActivateEvent((event) => {
					if (link.hash == location.hash)
						Sidenotes.updateStateAfterHashChange();
				});
			});
		}, "eventListeners", (info) => info.document == document);

		/*  In footnote mode (ie. on viewports too narrow to support sidenotes),
			footnote reference links (i.e., citations) should point down to
			footnotes (this is the default state). But in sidenote mode,
			footnote reference links should point to sidenotes.

			We therefore rewrite all footnote reference links appropriately to
			the current mode (based on viewport width).

			We also add an active media query to rewrite the links if a change
			in viewport width results in switching modes, as well as an event
			handler to rewrite footnote reference links in transcluded content.
		 */
		doWhenMatchMedia(Sidenotes.mediaQueries.viewportWidthBreakpoint, "Sidenotes.rewriteCitationTargetsForCurrentMode", (mediaQuery) => {
			document.querySelectorAll("a.footnote-ref").forEach(citation => {
				citation.href = (mediaQuery.matches ? "#sn" : "#fn") + Notes.noteNumberFromHash(citation.hash);
			});
		}, null, (mediaQuery) => {
			document.querySelectorAll("a.footnote-ref").forEach(citation => {
				citation.href = "#fn" + Notes.noteNumberFromHash(citation.hash);
			});
		});

		addContentLoadHandler(Sidenotes.rewriteCitationTargetsInLoadedContent = (eventInfo) => {
			document.querySelectorAll("a.footnote-ref").forEach(citation => {
				if (citation.pathname == location.pathname)
					citation.href = (Sidenotes.mediaQueries.viewportWidthBreakpoint.matches ? "#sn" : "#fn")
									+ Notes.noteNumberFromHash(citation.hash);
			});
		}, "rewrite", (info) => info.document == document);

		/*	What happens if the page loads with a URL hash that points to a
			sidenote or footnote or citation? We need to scroll appropriately,
			and do other adjustments, just as we do when the hash updates.
		 */
		GW.notificationCenter.addHandlerForEvent("Sidenotes.sidenotePositionsDidUpdate", Sidenotes.updateStateAfterHashChange = (info) => {
			GWLog("Sidenotes.updateStateAfterHashChange", "sidenotes.js", 1);

			//	Update highlighted state of sidenote and citation, if need be.
			Sidenotes.updateTargetCounterpart();

			/*	If hash targets a sidenote, reveal corresponding citation; and
				vice-versa. Scroll everything into view properly.
			 */
			if (location.hash.match(/#sn[0-9]/)) {
				let citation = document.querySelector("#fnref" + Notes.noteNumberFromHash());
				if (citation == null)
					return;

				let sidenote = Sidenotes.counterpart(citation);

				revealElement(citation, {
					scrollIntoView: false
				});

				Sidenotes.slideLockSidenote(sidenote);

				requestAnimationFrame(() => {
					scrollElementIntoView(sidenote, {
						offset: (-1 * (Sidenotes.sidenotePadding + 1))
					});

					Sidenotes.unSlideLockSidenote(sidenote);
				});
			} else if (location.hash.match(/#fnref[0-9]/)) {
				let citation = getHashTargetedElement();
				let sidenote = Sidenotes.counterpart(citation);

				Sidenotes.slideLockSidenote(sidenote);

				requestAnimationFrame(() => {
					let sidenoteRect = sidenote.getBoundingClientRect();
					let citationRect = citation.getBoundingClientRect();
					if (   sidenoteRect.top < Sidenotes.sidenotePadding + 1
						&& citationRect.bottom + (-1 * (sidenoteRect.top - Sidenotes.sidenotePadding)) < window.innerHeight)
						scrollElementIntoView(sidenote, {
							offset: (-1 * (Sidenotes.sidenotePadding + 1))
						});

					Sidenotes.unSlideLockSidenote(sidenote);
				});
			}

			/*	Hide mode selectors, as they would otherwise overlap a
				sidenote thatâ€™s on the top-right.
			 */
			if (Notes.noteNumberFromHash() > "")
				Sidenotes.hideInterferingUIElements();
		}, { once: true });

		//	Add event listeners, and the switch between modes.
		doWhenMatchMedia(Sidenotes.mediaQueries.viewportWidthBreakpoint, "Sidenotes.addOrRemoveEventHandlersForCurrentMode", (mediaQuery) => {
			doWhenPageLayoutComplete(Sidenotes.updateSidenotePositionsIfNeeded);

			/*  After the hash updates, properly highlight everything, if needed.
				Also, if the hash points to a sidenote whose citation is in a
				collapse block, expand it and all collapse blocks enclosing it.
			 */
			GW.notificationCenter.addHandlerForEvent("GW.hashDidChange", Sidenotes.updateStateAfterHashChange);

			/*	Add event handler to (asynchronously) recompute sidenote positioning
				when full-width media lazy-loads.
			 */
			GW.notificationCenter.addHandlerForEvent("Rewrite.fullWidthMediaDidLoad", Sidenotes.updateSidenotePositionsAfterFullWidthMediaDidLoad = (info) => {
				if (isWithinCollapsedBlock(info.mediaElement))
					return;

				doWhenPageLayoutComplete(Sidenotes.updateSidenotePositionsIfNeeded);
			});

			/*	Add event handler to (asynchronously) recompute sidenote positioning
				when collapse blocks are expanded/collapsed.
			 */
			GW.notificationCenter.addHandlerForEvent("Collapse.collapseStateDidChange", Sidenotes.updateSidenotePositionsAfterCollapseStateDidChange = (info) => {
				doWhenPageLayoutComplete(Sidenotes.updateSidenotePositionsIfNeeded);
			}, { condition: (info) => (info.collapseBlock.closest("#markdownBody") != null) });

			/*	Add event handler to (asynchronously) recompute sidenote positioning
				when new content is loaded (e.g. via transclusion).
			 */
			GW.notificationCenter.addHandlerForEvent("Rewrite.contentDidChange", Sidenotes.updateSidenotePositionsAfterContentDidChange = (info) => {
				doWhenPageLayoutComplete(Sidenotes.updateSidenotePositionsIfNeeded);
			}, { condition: (info) => (info.document == document) });

			/*  Add a resize listener so that sidenote positions are recalculated when
				the window is resized.
			 */
			addWindowResizeListener(Sidenotes.windowResized = (event) => {
				GWLog("Sidenotes.windowResized", "sidenotes.js", 2);

				doWhenPageLayoutComplete(Sidenotes.updateSidenotePositionsIfNeeded);
			}, {
				name: "Sidenotes.updateSidenotePositionsOnWindowResizeListener"
			});

			/*	Add handler to bind more sidenote-slide events if more
				citations are injected (e.g., in a popup).
			 */
			addContentInjectHandler(Sidenotes.bindAdditionalSidenoteSlideEvents = (eventInfo) => {
				eventInfo.container.querySelectorAll("a.footnote-ref").forEach(citation => {
					if (citation.pathname != location.pathname)
						return;

					let sidenote = Sidenotes.counterpart(citation);
					citation.addEventListener("mouseenter", citation.onCitationMouseEnterSlideSidenote = (event) => {
						Sidenotes.putAllSidenotesBack(sidenote);
						requestAnimationFrame(() => {
							Sidenotes.slideSidenoteIntoView(sidenote, true);
						});
					});
				});
			}, "eventListeners", (info) => info.document != document);

			/*	Add a scroll listener to un-slide all sidenotes on scroll.
			 */
			addScrollListener((event) => {
				Sidenotes.putAllSidenotesBack();
			}, {
				name: "Sidenotes.unSlideSidenotesOnScrollListener",
				defer: true
			});
		}, (mediaQuery) => {
			/*	Deactivate event handlers.
			 */
			GW.notificationCenter.removeHandlerForEvent("GW.hashDidChange", Sidenotes.updateStateAfterHashChange);
			GW.notificationCenter.removeHandlerForEvent("Rewrite.contentDidChange", Sidenotes.updateSidenotePositionsAfterContentDidChange);
			GW.notificationCenter.removeHandlerForEvent("Rewrite.fullWidthMediaDidLoad", Sidenotes.updateSidenotePositionsAfterFullWidthMediaDidLoad);
			GW.notificationCenter.removeHandlerForEvent("Collapse.collapseStateDidChange", Sidenotes.updateSidenotePositionsAfterCollapseStateDidChange);
			GW.notificationCenter.removeHandlerForEvent("GW.contentDidInject", Sidenotes.bindAdditionalSidenoteSlideEvents);
			removeScrollListener("Sidenotes.unSlideSidenotesOnScroll");
			removeWindowResizeListener("Sidenotes.recalculateSidenotePositionsOnWindowResize");
		}, (mediaQuery) => {
			/*	Deactivate event handlers.
			 */
			GW.notificationCenter.removeHandlerForEvent("GW.hashDidChange", Sidenotes.updateStateAfterHashChange);
			GW.notificationCenter.removeHandlerForEvent("Rewrite.contentDidChange", Sidenotes.updateSidenotePositionsAfterContentDidChange);
			GW.notificationCenter.removeHandlerForEvent("Rewrite.fullWidthMediaDidLoad", Sidenotes.updateSidenotePositionsAfterFullWidthMediaDidLoad);
			GW.notificationCenter.removeHandlerForEvent("Collapse.collapseStateDidChange", Sidenotes.updateSidenotePositionsAfterCollapseStateDidChange);
			GW.notificationCenter.removeHandlerForEvent("GW.contentDidInject", Sidenotes.bindAdditionalSidenoteSlideEvents);
			removeScrollListener("Sidenotes.unSlideSidenotesOnScroll");
			removeWindowResizeListener("Sidenotes.recalculateSidenotePositionsOnWindowResize");
		});

		//	Once the sidenotes are constructed, lay them out.
		GW.notificationCenter.addHandlerForEvent("Sidenotes.sidenotesDidConstruct", (info) => {
			//	Lay out sidenotes once page layout is complete.
			doWhenPageLayoutComplete(() => {
				Sidenotes.updateSidenotePositionsIfNeeded();

				//	Add listener to lay out sidenotes when they are re-constructed.
				GW.notificationCenter.addHandlerForEvent("Sidenotes.sidenotesDidConstruct", (info) => {
					//	Update highlighted state of sidenote and citation, if need be.
					Sidenotes.updateTargetCounterpart();

					//	Update sidenote positions.
					Sidenotes.updateSidenotePositionsIfNeeded();
				});
			});
		}, { once: true });

		/*  Construct the sidenotes whenever content is injected into the main
			page (including the initial page load).
		 */
		addContentInjectHandler(GW.contentInjectHandlers.constructSidenotesWhenMainPageContentDidInject = (eventInfo) => {
			GWLog("constructSidenotesWhenMainPageContentDidInject", "sidenotes.js", 1);

			if (eventInfo.container == document.main) {
				Sidenotes.constructSidenotes();
			} else {
				Sidenotes.sidenotesNeedConstructing = true;
				requestIdleCallback(() => {
					if (Sidenotes.sidenotesNeedConstructing == true) {
						Sidenotes.constructSidenotes();
						Sidenotes.sidenotesNeedConstructing = false;
					}
				});
			}
		}, "rewrite", (info) => (   info.document == document
								 && info.source != "Sidenotes.constructSidenotes"
								 && info.container.closest(".sidenote") == null));

		GW.notificationCenter.fireEvent("Sidenotes.setupDidComplete");
	},

	hideInterferingUIElements: () => {
		requestAnimationFrame(() => {
			setTimeout(() => {
				//	Page toolbar.
				GW.pageToolbar.toggleCollapseState(true);
				GW.pageToolbar.fade();

				//	Back-to-top link.
				GW.backToTop.classList.toggle("hidden", true)
			}, 25);
		});
	},

	/**************/
	/*	Slidenotes.
	 */

	displacedSidenotes: [ ],

	/*	If the sidenote is offscreen, slide it onto the screen.
	 */
	slideSidenoteIntoView: (sidenote, toCitation) => {
		GWLog("Sidenotes.slideSidenoteIntoView", "sidenotes.js", 3);

		Sidenotes.hideInterferingUIElements();

		if (sidenote.style.transform == "none")
			return;

		let minDistanceFromScreenEdge = Sidenotes.sidenotePadding + 1.0;

		let sidenoteRect = sidenote.getBoundingClientRect();
		if (   sidenoteRect.top >= minDistanceFromScreenEdge
			&& sidenoteRect.bottom <= window.innerHeight - minDistanceFromScreenEdge)
			return;

		let newSidenoteTop = sidenoteRect.top;
		if (toCitation) {
			let citationRect = Sidenotes.counterpart(sidenote).getBoundingClientRect()

			//	Down to citation.
			newSidenoteTop = Math.max(sidenoteRect.top, minDistanceFromScreenEdge, citationRect.top);

			//	Up to citation.
			newSidenoteTop = Math.min(newSidenoteTop + sidenoteRect.height,
									  window.innerHeight - minDistanceFromScreenEdge,
									  citationRect.top + sidenoteRect.height)
						   - sidenoteRect.height;

			//	Down to viewport top.
			newSidenoteTop = Math.max(newSidenoteTop, minDistanceFromScreenEdge);
		} else {
			//	Down to viewport top.
			newSidenoteTop = Math.max(sidenoteRect.top, minDistanceFromScreenEdge);

			//	Up to viewport bottom.
			newSidenoteTop = Math.min(newSidenoteTop + sidenoteRect.height,
									  window.innerHeight - minDistanceFromScreenEdge)
						   - sidenoteRect.height;
		}

		let delta = Math.round(newSidenoteTop - sidenoteRect.top);
		if (delta) {
			sidenote.style.transform = `translateY(${delta}px)`;
			sidenote.classList.toggle("displaced", true);
			if (Sidenotes.displacedSidenotes.includes(sidenote) == false)
				Sidenotes.displacedSidenotes.push(sidenote);
		}
	},

	/*	Un-slide a slid-onto-the-screen sidenote.
	 */
	putSidenoteBack: (sidenote) => {
		GWLog("Sidenotes.putSidenoteBack", "sidenotes.js", 3);

		if (sidenote.style.transform == "none")
			return;

		sidenote.style.transform = "";
		sidenote.classList.toggle("displaced", false);
	},

	/*	Un-slide all sidenotes (possibly except one).
	 */
	putAllSidenotesBack: (exceptOne = null) => {
		GWLog("Sidenotes.putAllSidenotesBack", "sidenotes.js", 3);

		Sidenotes.displacedSidenotes.forEach(sidenote => {
			if (sidenote == exceptOne)
				return;

			Sidenotes.putSidenoteBack(sidenote);
		});
		Sidenotes.displacedSidenotes = exceptOne ? [ exceptOne ] : [ ];
	},

	/*	Instantly un-slide sidenote and make it un-slidable.
	 */
	slideLockSidenote: (sidenote) => {
		GWLog("Sidenotes.slideLockSidenote", "sidenotes.js", 3);

		sidenote.style.transition = "none";
		sidenote.style.transform = "none";
		sidenote.classList.toggle("displaced", false);
	},

	/*	Instantly un-slide sidenote and make it slidable.
	 */
	unSlideLockSidenote: (sidenote) => {
		GWLog("Sidenotes.unSlideLockSidenote", "sidenotes.js", 3);

		sidenote.style.transform = "";
		sidenote.style.transition = "";
		sidenote.classList.toggle("displaced", false);
	},
};

GW.notificationCenter.fireEvent("Sidenotes.didLoad");

//  LET... THERE... BE... SIDENOTES!!!
Sidenotes.setup();
