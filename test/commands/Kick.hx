package test.commands;

import discordhx.permission.Permission;
import discordhx.guild.GuildMember;
import discordbothx.core.DiscordBot;
import discordhx.guild.Guild;
import discordhx.channel.TextChannel;
import discordhx.channel.GroupDMChannel;
import discordhx.channel.ChannelType;
import discordhx.channel.Channel;
import discordbothx.service.BaseCommand;
import discordbothx.core.CommunicationContext;
import discordbothx.service.ICommandDefinition;

class Kick extends BaseCommand implements ICommandDefinition {
    public var paramsUsage:String = '<Mention of the future-ex-member> *<Mention of hypothetical other future-ex-members>*';
    public var nbRequiredParams: Int = 1;
    public var description:String = 'Kick someone out of this server!';
    public var hidden:Bool = false;

    public function process(args:Array<String>):Void {
        var channel: Channel = cast context.message.channel;

        if (channel.type == ChannelType.TEXT) {
            if (context.message.mentions.users.size > 0) {
                var guildChannel: TextChannel = cast context.message.channel;
                var guild: Guild = guildChannel.guild;
                var guildMember: GuildMember = guild.member(DiscordBot.instance.client.user);

                if (guildMember.hasPermission(Permission.KICK_MEMBERS)) {
                    for (user in context.message.mentions.users.keyArray()) {
                        guild.member(user).kick();
                    }

                    context.sendToChannel('**Took care of it.**  (⌐■_■)–︻╦╤─ `dead`');
                } else {
                    context.sendToChannel('Mate, I can\'t find my gun!\n\n*(Meaning I don\'t have the right to kick members in this server)*');
                }
            } else {
                context.sendToChannel('Mate, if you don\'t mention anyone, I can\'t guess who you want to kick...');
            }
        } else {
            context.sendToChannel('Mate, you really think I can kick people out of a private conversation?');
        }
    }
}
