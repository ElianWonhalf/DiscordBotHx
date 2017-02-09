package test.commands;

import discordbothx.service.BaseCommand;
import discordbothx.core.CommunicationContext;
import discordbothx.service.ICommandDefinition;

class Roll extends BaseCommand implements ICommandDefinition {
    public var paramsUsage:String = '<The maximum>';
    public var nbRequiredParams: Int = 1;
    public var description:String = 'Want to roll a dice? Just tell me how many faces it has!';
    public var hidden:Bool = false;

    public function process(args:Array<String>):Void {
        if (!Math.isNaN(cast args.join(' '))) {
            var max = Std.parseInt(cast args.join(' '));

            if (max <= 9007199254740991) {
                context.sendToChannel('Rolled a dice with ' + max + ' faces, got **' + Math.ceil(Math.random() * max) + '**');
            } else {
                context.sendToChannel('Mate, what kind of game are you playing there?');
            }
        } else {
            context.sendToChannel('Mate, you kidding me, right?');
        }
    }
}
