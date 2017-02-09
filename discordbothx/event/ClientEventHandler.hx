package discordbothx.event;

import discordbothx.service.Command;
import discordbothx.service.Chat;
import discordhx.channel.ChannelType;
import discordhx.channel.Channel;
import discordbothx.core.CommunicationContext;
import discordbothx.service.Chat;
import discordbothx.log.Logger;
import haxe.Timer;
import discordhx.user.User;
import discordhx.message.Message;
import discordhx.client.Client;
import discordhx.client.Client.ClientEvent;
import discordbothx.core.DiscordBot;

class ClientEventHandler extends EventHandler<Client> {
    private override function process(): Void {
        _eventEmitter.on(ClientEvent.READY, readyHandler);
        _eventEmitter.on(ClientEvent.MESSAGE, messageHandler);
        _eventEmitter.on(ClientEvent.MESSAGE_UPDATE, messageUpdatedHandler);
        _eventEmitter.on(ClientEvent.DISCONNECT, disconnectedHandler);
    }

    private function readyHandler(): Void {
        var nbGuilds = _eventEmitter.guilds.array().length;
        var guildWord = 'guild';

        if (nbGuilds > 1) {
            guildWord += 's';
        }

        Logger.info('Connected! Serving in ' + nbGuilds + ' ' + guildWord + '.');

        if (Chat.isFeatureEnabled()) {
            Chat.initialize();
        }
    }

    private function messageHandler(message: Message): Void {
        if (!message.author.bot) {
            handleMessage(message);
        }
    }

    private function messageUpdatedHandler(oldMessage: Message, newMessage: Message): Void {
        if (oldMessage.content != newMessage.content && !newMessage.author.bot) {
            handleMessage(newMessage, true, oldMessage);
        }
    }

    private function handleMessage(message: Message, edited = false, oldMessage: Message = null): Void {
        var context: CommunicationContext = new CommunicationContext(message);
        var commandIdentifier: String = DiscordBot.instance.commandIdentifier;
        var isCommand: Bool = message.content.substr(0, commandIdentifier.length) == commandIdentifier;
        var isInPrivate: Bool = message.guild == null;

        if (isCommand) {
            if (Command.isFeatureActive()) {
                if (edited) {
                    Logger.info('Handling edited message from ' + oldMessage.author.username);
                }

                Logger.info('Command called by ' + message.author.username + ': ' + message.cleanContent);

                Command.instance.process(context);
            }
        } else {
            //var isForMe: Bool = message.isMemberMentioned(DiscordBot.instance.client.user); @TODO
            var botIsMentioned: Bool = message.mentions.everyone || message.mentions.users.has(DiscordBot.instance.client.user.id);

            if (botIsMentioned) {
                if (Chat.isFeatureEnabled()) {
                    if (edited) {
                        Logger.notice('Handling edited message from ' + oldMessage.author.username);
                    }

                    Logger.info('Chat input from ' + message.author.username + ': ' + message.cleanContent);
                    Chat.instance.ask(context);
                }
            } else if (isInPrivate) {
                NotificationBus.instance.chatInPrivate.dispatch(context);

                if (Chat.isFeatureEnabled() && DiscordBot.instance.chatInPrivate) {
                    if (edited) {
                        Logger.notice('Handling edited message from ' + oldMessage.author.username);
                    }

                    Logger.info('Chat input from ' + message.author.username + ': ' + message.cleanContent);
                    Chat.instance.ask(context);
                }
            }
        }
    }

    private function disconnectedHandler(): Void {
        Logger.info('Disconnected!');

        Timer.delay(function () {
            Logger.info('Trying to reconnect...');

            DiscordBot.instance.client.destroy().then(cast function () {
                DiscordBot.instance.login();
            });
        }, 1000);
    }
}
