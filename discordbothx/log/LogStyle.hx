package discordbothx.log;

@:enum
abstract LogStyle(String) to String {
    var RESET = '\x1b[0m';
    var BOLD_ON = '\x1b[1m';
    var BOLD_OFF = '\x1b[22m';
    var INVERSE_ON = '\x1b[7m';
    var FOREGROUND_BLACK = '\x1b[30m';
    var FOREGROUND_RED = '\x1b[31m';
    var FOREGROUND_GREEN = '\x1b[32m';
    var FOREGROUND_YELLOW = '\x1b[33m';
    var FOREGROUND_BLUE = '\x1b[34m';
    var FOREGROUND_MAGENTA = '\x1b[35m';
    var FOREGROUND_CYAN = '\x1b[36m';
    var FOREGROUND_WHITE = '\x1b[33m';
    var BACKGROUND_RED = '\x1b[41m';
    var BACKGROUND_GREEN = '\x1b[42m';
}
