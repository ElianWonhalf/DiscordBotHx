package test.commands;

import discordhx.user.User;
import discordbothx.service.BaseCommand;
import discordbothx.core.CommunicationContext;
import discordbothx.service.ICommandDefinition;

class Avatar extends BaseCommand implements ICommandDefinition {
    public var paramsUsage:String = '*<Mention of someone>*';
    public var nbRequiredParams: Int = 0;
    public var description:String = 'Display someone\'s avatar';
    public var hidden:Bool = false;

    public function process(args:Array<String>):Void {
        var user: User = null;

        if (context.message.mentions.users.size > 0) {
            user = context.message.mentions.users.first();
        } else {
            user = context.message.author;
        }

        context.sendFileToChannel(user.displayAvatarURL, user.id + '.jpg');
    }
}
