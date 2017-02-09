package discordbothx.log;

import nodejs.Console;
import discordbothx.log.LoggerDesigner;

class Logger {
    public static function info(msg: String) {
        Console.info(LogStyle.FOREGROUND_GREEN, LoggerDesigner.instance.design(msg, LogLevel.INFO), LogStyle.RESET);
    }

    public static function error(msg: String) {
        Console.error(LogStyle.FOREGROUND_RED, LoggerDesigner.instance.design(msg, LogLevel.ERROR), LogStyle.RESET);
    }

    public static function warning(msg: String) {
        Console.warn(LogStyle.FOREGROUND_YELLOW, LoggerDesigner.instance.design(msg, LogLevel.WARNING), LogStyle.RESET);
    }

    public static function notice(msg: String) {
        Console.log(LogStyle.FOREGROUND_BLUE, LoggerDesigner.instance.design(msg, LogLevel.NOTICE), LogStyle.RESET);
    }

    public static function exception(exception: Dynamic) {
        Console.error('', LogStyle.BOLD_ON);
        Console.error(LogStyle.BACKGROUND_RED, '                             ');
        Console.error(' Ugh. What... What happenned? ');
        Console.error('                             ', LogStyle.RESET);
        Console.error(' ', exception, '');
    }

    public static function debug(element: Dynamic) {
        Console.log('', LogStyle.BOLD_ON);
        Console.log(LogStyle.BACKGROUND_GREEN, '                                       ');
        Console.log(' Wait, I wanna see that more clearly... ');
        Console.log('                                       ', LogStyle.RESET);
        Console.log(' ', element, '');
    }

    public static function end() {
        Console.log('', LogStyle.BOLD_ON);
        Console.log(LogStyle.BACKGROUND_GREEN, '                                            ');
        Console.log(' You really want me to die, don\'t you? Fine. ');
        Console.log('                                            ', LogStyle.RESET);
    }
}
