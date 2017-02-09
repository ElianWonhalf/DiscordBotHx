package test.commands;

import discordbothx.service.BaseCommand;
import discordbothx.core.CommunicationContext;
import discordbothx.service.ICommandDefinition;

class Say extends BaseCommand implements ICommandDefinition {
    public var paramsUsage:String = '<What you want me to say>';
    public var nbRequiredParams: Int = 1;
    public var description:String = 'Make me say something!';
    public var hidden:Bool = false;

    public function process(args:Array<String>):Void {
        context.sendToChannel(args.join(' '));
    }
}
