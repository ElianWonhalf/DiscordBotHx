package test;

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

        bot.helpDialogHeader = 'Hello there! This is the DiscordBotHx framework default help dialog! Here, you can check every available command.';
        bot.helpDialogFooter = 'Hope you\'re having fun with this bot!';

        bot.commands.set('ping', Ping);
        bot.commands.set('say', Say);
        bot.commands.set('kick', Kick);
        bot.commands.set('roll', Roll);
        bot.commands.set('avatar', Avatar);

        bot.login();
    }

    public static function get_instance() {
        if (instance == null) {
            instance = new TestBot();
        }

        return instance;
    }

    public static function main() {
        new TestBot();
    }
}
