package discordbothx.service;

import discordbothx.core.CommunicationContext;

class BaseCommand {
    public var nbRequiredParams: Int = 0;
    public var paramsUsage:String = '';
    public var description:String = '';
    public var hidden:Bool = false;

    private var context: CommunicationContext;

    public function new(context: CommunicationContext): Void {
        this.context = context;
    }

    public function checkFormat(args: Array<String>): Bool {
        return args.length >= nbRequiredParams;
    }

    public function process(args: Array<String>): Void {}
}
