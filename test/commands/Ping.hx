package test.commands;

import discordbothx.service.BaseCommand;
import discordbothx.core.CommunicationContext;
import discordbothx.service.ICommandDefinition;

class Ping extends BaseCommand implements ICommandDefinition {
    public var paramsUsage:String = '';
    public var nbRequiredParams: Int = 0;
    public var description:String = 'Ping? Pong!';
    public var hidden:Bool = false;

    public function process(args:Array<String>):Void {
        context.sendToChannel('Pong!');
    }
}
