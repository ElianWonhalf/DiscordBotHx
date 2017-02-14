package test;

import discordbothx.log.Logger;
import discordbothx.event.NotificationBus;
import test.service.PermissionSystem;
import discordbothx.core.CommunicationContext;
import test.commands.Avatar;
import test.commands.Roll;
import test.commands.Kick;
import test.commands.Say;
import test.commands.Ping;
import test.auth.AuthDetails;
import discordbothx.core.DiscordBot;

class TestBot {
    public static var instance(get, null): TestBot;

    public var bot: DiscordBot;

    private function new() {
        bot = DiscordBot.instance;

        bot.authDetails = new AuthDetails();
        bot.permissionSystem = new PermissionSystem();

        bot.helpDialogHeader = function (context: CommunicationContext): String {
            return 'Hello there! This is the DiscordBotHx framework default help dialog! Here, you can check every available command.';
        };
        bot.helpDialogFooter = function (context: CommunicationContext): String {
            return 'Hope you\'re having fun with this bot!';
        };

        bot.commands.set('ping', Ping);
        bot.commands.set('say', Say);
        bot.commands.set('kick', Kick);
        bot.commands.set('roll', Roll);
        bot.commands.set('avatar', Avatar);

        bindSignals();
        bot.login();
    }

    public static function get_instance() {
        if (instance == null) {
            instance = new TestBot();
        }

        return instance;
    }

    public static function main() {
        instance = new TestBot();
    }

    private function bindSignals(): Void {
        NotificationBus.instance.cleverbotErrorNotReady.add(function (context: CommunicationContext): Void {
            context.sendToChannel('Conversation interface not yet initialized, please wait...');
        });
        NotificationBus.instance.cleverbotErrorBotSuspected.add(function (context: CommunicationContext): Void {
            context.sendToChannel('I think that ' + context.message.author.username + ' might be a bot.');
        });

        NotificationBus.instance.checkPermissionError.add(function (context: CommunicationContext, command: String): Void {
            context.sendToChannel('Sorry ' + context.message.author + ', there has been a problem while retrieving your permissions.');
        });
        NotificationBus.instance.getDeniedCommandListError.add(function (context: CommunicationContext): Void {
            context.sendToChannel('Sorry ' + context.message.author + ', there has been a problem while retrieving the list.');
        });

        NotificationBus.instance.noLastCommand.add(function (context: CommunicationContext): Void {
            context.sendToChannel('Sorry ' + context.message.author + ', no command has been executed on this channel since I am connected.');
        });
        NotificationBus.instance.unauthorizedCommand.add(function (context: CommunicationContext, command: String): Void {
            context.sendToChannel('Sorry ' + context.message.author + ', you don\'t have the right to execute this command.');
        });

        NotificationBus.instance.helpDialogSent.add(function (context: CommunicationContext): Void {
            context.sendToChannel('I just sent you a list of the commands I can answer to in DM, ' + context.message.author + '.');
        });
        NotificationBus.instance.sendHelpDialogError.add(function (context: CommunicationContext): Void {
            context.sendToChannel('Sorry ' + context.message.author + ', there has been an error while sending the help dialog.');
        });
    }
}
