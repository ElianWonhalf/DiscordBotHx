package test.commands;

import discordbothx.service.BaseCommand;
import discordbothx.core.CommunicationContext;

class Ping extends BaseCommand {
    public function new(context: CommunicationContext): Void {
        super(context);

        description = 'Ping? Pong!';
    }

    override public function process(args: Array<String>): Void {
        context.sendToChannel('Pong!');
    }
}
