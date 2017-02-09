package discordbothx.external.cleverbotio;

@:native('(require("cleverbot.io"))')
extern class CleverbotIO {
    public function new(user: String, key: String, ?nick: String): Void;
    public function setNick(sessionName: String): Void;
    public function create(callback: Dynamic->String->Void): Void;
    public function ask(message: String, callback: Dynamic->String->Void): Void;
}
