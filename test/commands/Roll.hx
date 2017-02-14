package test.commands;

import discordbothx.service.BaseCommand;
import discordbothx.core.CommunicationContext;

class Roll extends BaseCommand {
    public function new(context: CommunicationContext): Void {
        super(context);

        paramsUsage = '<The maximum>';
        nbRequiredParams = 1;
        description = 'Want to roll a dice? Just tell me how many faces it has!';
    }

    override public function process(args: Array<String>): Void {
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

    override public function checkFormat(args: Array<String>): Bool {
        return args.length == nbRequiredParams && !Math.isNaN(cast args.join(' '));
    }
}
