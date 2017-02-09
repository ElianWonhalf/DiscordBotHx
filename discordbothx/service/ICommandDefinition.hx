package discordbothx.service;

interface ICommandDefinition {
    public var paramsUsage: String;
    public var nbRequiredParams: Int;
    public var description: String;
    public var hidden: Bool;

    public function process(args: Array<String>): Void;
}
