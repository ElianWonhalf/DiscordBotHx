package discordbothx.service;

import discordhx.channel.TextChannel;
import discordhx.RichEmbed;
import discordhx.Collection;
import discordhx.channel.GuildChannel;
import discordbothx.core.DiscordBot;
import discordbothx.event.NotificationBus;
import discordhx.channel.Channel;
import discordbothx.log.Logger;
import discordhx.message.Message;
import discordbothx.core.CommunicationContext;

class Command {
    public static var instance(get, null): Command;

    private var lastCommand: Map<String, CommandCaller>;

    public static function get_instance(): Command {
        if (instance == null) {
            instance = new Command();
        }

        return instance;
    }

    public static function isFeatureActive(): Bool {
        return DiscordBot.instance.commands.size > 0;
    }

    private function new() {
        lastCommand = new Map<String, CommandCaller>();
    }

    public function process(context: CommunicationContext): Void {
        var message: Message = context.message;
        var content = message.content;

        if (content.indexOf(DiscordBot.instance.commandIdentifier) == 0) {
            content = content.substr(DiscordBot.instance.commandIdentifier.length);
        }

        var args = content.split(' ');
        var command = args.shift().toLowerCase();

        if (DiscordBot.instance.commands.has(command)) {
            requestExecuteCommand(context, command, args);
        } else {
            if (command == 'help') {
                if (args.length > 0 && DiscordBot.instance.commands.has(args[0])) {
                    requestExecuteCommand(context, args[0], ['-h']);
                } else if (DiscordBot.instance.handleHelpDialog) {
                    displayHelpDialog(context);
                }
            } else if (command == DiscordBot.instance.commandIdentifier) {
                requestExecuteLastCommand(context, args);
            } else {
                NotificationBus.instance.unknownCommand.dispatch(context, command);
            }
        }
    }

    private function requestExecuteLastCommand(context: CommunicationContext, additionnalArgs: Array<String>): Void {
        var lastCommand = retrieveLastCommand(context);

        if (lastCommand == null) {
            NotificationBus.instance.noLastCommand.dispatch(context);
        } else {
            requestExecuteCommand(context, lastCommand.name, lastCommand.args.concat(additionnalArgs));
        }
    }

    private function retrieveLastCommand(context: CommunicationContext): CommandCaller {
        var ret: CommandCaller = null;
        var channel: Channel = context.message.channel;

        if (lastCommand.exists(channel.id)) {
            ret = lastCommand.get(channel.id);
        }

        return ret;
    }

    private function requestExecuteCommand(context: CommunicationContext, command: String, args: Array<String>): Void {
        if (command != DiscordBot.instance.commandIdentifier) {
            var author = context.message.author;

            DiscordBot.instance.permissionSystem.check(context, command).then(function (granted: Bool) {
                if (granted) {
                    var channel: Channel = cast context.message.channel;

                    lastCommand.set(channel.id, {
                        name: command,
                        args: args
                    });
                    var instance: ICommandDefinition = cast Type.createInstance(cast DiscordBot.instance.commands.get(command), [context]);

                    if (args.length < instance.nbRequiredParams || args[0] == '--help' || args[0] == '-h') {
                        var sendableChannel: SendableChannel = cast context.message.channel;
                        var embed = new RichEmbed();
                        var usage = DiscordBot.instance.commandIdentifier + command + ' ' + instance.paramsUsage;

                        embed.setTitle('The ' + command + ' command');
                        embed.setDescription(instance.description + '\n\n' + usage);
                        embed.setColor(DiscordUtils.getMaterialUIColor());

                        sendableChannel.sendEmbed(embed);
                    } else {
                        instance.process(args);
                    }
                } else {
                    var location: String = null;

                    if (context.message.guild == null) {
                        location = 'It was on a private conversation (date : ' + Date.now().toString() + ').';
                    } else {
                        var guildChannel: GuildChannel = cast context.message.channel;

                        location = 'It was on server ' + guildChannel.guild.name + ' and on channel #' + guildChannel.name + ' (date : ' + Date.now().toString() + ').';
                    }

                    Logger.warning('User ' + author.username + ' (' + author.id + ') tried to execute command ' + command + ' with arguments "' + args.join(' ') + '" but doesn\'t have rights. ' + location);
                    NotificationBus.instance.unauthorizedCommand.dispatch(context, command);
                }
            }).catchError(function (error: Dynamic) {
                Logger.error('Error while trying to retrieve permissions for command ' + command);
                Logger.exception(error);
                NotificationBus.instance.checkPermissionError.dispatch(context, command);
            });
        } else {
            var instance: ICommandDefinition = cast Type.createInstance(cast DiscordBot.instance.commands.get(command), [context]);
            instance.process(args);
        }
    }

    private function displayHelpDialog(context: CommunicationContext): Void {
        var author = context.message.author;

        DiscordBot.instance.permissionSystem.getDeniedCommandList(context).then(function (deniedCommandList: Array<String>) {
            var output: String = '';
            var content = new Array<String>();

            if (DiscordBot.instance.helpDialogHeader != null) {
                output = DiscordBot.instance.helpDialogHeader(context) + '\n\n\n';
            }

            for (cmd in DiscordBot.instance.commands.keyArray()) {
                var instance: ICommandDefinition = cast Type.createInstance(cast DiscordBot.instance.commands.get(cmd), [context]);

                var hidden = instance.hidden;
                var usage = instance.paramsUsage;
                var description = instance.description;

                if (!hidden && deniedCommandList.indexOf(cmd) < 0) {
                    output += '\t**' + DiscordBot.instance.commandIdentifier + cmd + ' ' + usage + '**\n\t\t*' + description + '*\n\n';
                }
            }

            if (DiscordBot.instance.helpDialogFooter != null) {
                output += '\n' + DiscordBot.instance.helpDialogFooter(context);
            }

            content = DiscordUtils.splitLongMessage(output);

            sendHelpDialog(context, content, 0, function (context: CommunicationContext) {
                NotificationBus.instance.helpDialogSent.dispatch(context);
            });
        }).catchError(function (error: Dynamic) {
            Logger.error('Error while retrieving the denied command list');
            Logger.exception(error);
            NotificationBus.instance.getDeniedCommandListError.dispatch(context);
        });
    }

    private function sendHelpDialog(context: CommunicationContext, content: Array<String>, index: Int, callback: CommunicationContext->Void): Void {
        var messageSentCallback: Message->Void;

        if (index >= content.length - 1) {
            messageSentCallback = function(msg: Message) {
                callback(context);
            };
        } else {
            messageSentCallback = function(msg: Message) {
                sendHelpDialog(context, content, index + 1, callback);
            };
        }

        context.sendToAuthor(content[index]).then(messageSentCallback).catchError(function (error: Dynamic): Void {
            Logger.error('Error while sending help dialog');
            Logger.exception(error);
            NotificationBus.instance.sendHelpDialogError.dispatch(context);
        });
    }
}

typedef CommandCaller = {
    name: String,
    args: Array<String>
}
