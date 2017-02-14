package test.commands;

import discordhx.user.User;
import discordbothx.service.BaseCommand;
import discordbothx.core.CommunicationContext;

class Avatar extends BaseCommand {
    public function new(context: CommunicationContext): Void {
        super(context);

        paramsUsage = '*<Mention of someone>*';
        description = 'Display someone\'s avatar';
    }

    override public function process(args: Array<String>): Void {
        var user: User = null;

        if (context.message.mentions.users.size > 0) {
            user = context.message.mentions.users.first();
        } else {
            user = context.message.author;
        }

        context.sendFileToChannel(user.displayAvatarURL, user.id + '.jpg');
    }
}
