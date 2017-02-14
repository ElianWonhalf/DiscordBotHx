package test.commands;

import discordbothx.service.BaseCommand;
import discordbothx.core.CommunicationContext;

class Say extends BaseCommand {
    public function new(context: CommunicationContext): Void {
        super(context);

        paramsUsage = '<What you want me to say>';
        nbRequiredParams = 1;
        description = 'Make me say something!';
    }

    override public function process(args: Array<String>): Void {
        context.sendToChannel(args.join(' '));
    }
}
