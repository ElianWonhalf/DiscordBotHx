package discordbothx.log;

class LoggerDesigner {
    private static inline var PREFIX_LENGTH = 40;

    public static var instance(get, null):LoggerDesigner;

    private function new() {}

    public static function get_instance() {
        if (instance == null) {
            instance = new LoggerDesigner();
        }

        return instance;
    }

    public function design(log: String, level: LogLevel) {
        var date: String = Date.now().toString();
        var prefix: String = date + ' - ' + cast(level, String).toUpperCase();

        for (i in prefix.length...PREFIX_LENGTH) {
            prefix += ' ';
        }

        return prefix + ' | ' + log;
    }
}
