package discordbothx.service;

class DiscordUtils {
    public static inline var MESSAGE_MAX_LENGTH = 2000;

    public static function splitLongMessage(content: String): Array<String> {
        var splittedMessage = new Array<String>();

        if (content.length > MESSAGE_MAX_LENGTH) {
            while (content.length > 0) {
                var chunck = content.substr(0, MESSAGE_MAX_LENGTH);
                var splitPosition = chunck.lastIndexOf('\n');

                if (splitPosition < 0) {
                    splittedMessage.push(chunck.substr(0, MESSAGE_MAX_LENGTH));
                    content = content.substr(MESSAGE_MAX_LENGTH);
                } else {
                    splittedMessage.push(chunck.substr(0, splitPosition));
                    content = content.substr(splitPosition + 1);
                }
            }
        } else {
            splittedMessage.push(content);
        }

        return splittedMessage;
    }

    public static function getMaterialUIColor(): Int {
        var colors: Array<String> = [
            'F44336',
            'E91E63',
            '9C27B0',
            '673AB7',
            '3F51B5',
            '2196F3',
            '03A9F4',
            '00BCD4',
            '009688',
            '4CAF50',
            '8BC34A',
            'CDDC39',
            'FFEB3B',
            'FFC107',
            'FF9800',
            'FF5722',
            '795548',
            '9E9E9E',
            '607D8B'
        ];

        return Std.parseInt('0x' + colors[Math.floor(Math.random() * colors.length)]);
    }
}
