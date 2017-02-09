package discordbothx.log;

@:enum
abstract LogLevel(String) to String {
    var INFO = 'info';
    var WARNING = 'warning';
    var ERROR = 'error';
    var NOTICE = 'notice';
}
