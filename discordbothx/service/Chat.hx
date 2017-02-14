package discordbothx.service;

import StringTools;
import discordhx.role.Role;
import discordhx.channel.GuildChannel;
import discordhx.channel.Channel;
import discordbothx.core.IAuthDetailsProvider;
import discordbothx.external.htmlentities.Html5Entities;
import discordbothx.external.cleverbotio.CleverbotIO;
import discordbothx.event.NotificationBus;
import discordhx.channel.ChannelType;
import discordhx.channel.TextChannel;
import discordbothx.core.CommunicationContext;
import discordbothx.log.Logger;
import discordhx.message.Message;
import discordbothx.core.DiscordBot;
import discordhx.user.User;

class Chat {
    private static inline var MAX_FAST_ANSWER_DELAY = 1500; // In milliseconds
    private static inline var MAX_FAST_ANSWER_AMOUNT = 3;

    public static var instance(default, null): Chat;

    private var ready: Bool;
    private var error: Bool;
    private var cleverbot: CleverbotIO;
    private var html5Entities: Html5Entities;

    // Bot answer loop handling
    private var lastAnswerTimestamp: Map<String, Date>;
    private var nbFastAnswersLeft: Map<String, Int>;

    public static function isFeatureEnabled(): Bool {
        var authDetails: IAuthDetailsProvider = DiscordBot.instance.authDetails;
        var enabled: Bool = authDetails.CLEVERBOTIO_USER != null && authDetails.CLEVERBOTIO_KEY != null;

        return enabled;
    }

    public static function initialize(): Void {
        if (instance == null) {
            instance = new Chat();
        }
    }

    private function new(): Void {
        cleverbot = new CleverbotIO(
            DiscordBot.instance.authDetails.CLEVERBOTIO_USER,
            DiscordBot.instance.authDetails.CLEVERBOTIO_KEY
        );
        lastAnswerTimestamp = new Map<String, Date>();
        nbFastAnswersLeft = new Map<String, Int>();
        html5Entities = new Html5Entities();

        initializeNewSession();
    }

    public function initializeNewSession(): Void {
        ready = false;
        error = false;

        Logger.info('Initiating new Cleverbot session...');
        cleverbot.create(cleverbotPrepareHandler);
    }

    public function ask(context: CommunicationContext) {
        var user: User = DiscordBot.instance.client.user;
        var msg: Message = context.message;
        var msgTimestamp: Date = Date.now();
        var answer: Bool = true;
        var fastAnswersLeft: Int;

        if (!nbFastAnswersLeft.exists(msg.author.id)) {
            nbFastAnswersLeft.set(msg.author.id, MAX_FAST_ANSWER_AMOUNT);
        }

        fastAnswersLeft = nbFastAnswersLeft.get(msg.author.id);

        if (ready) {
            if (lastAnswerTimestamp.exists(msg.author.id)) {
                if (msgTimestamp.getTime() - lastAnswerTimestamp.get(msg.author.id).getTime() <= MAX_FAST_ANSWER_DELAY) {
                    if (fastAnswersLeft < 1) {
                        answer = false;
                        nbFastAnswersLeft.set(msg.author.id, MAX_FAST_ANSWER_AMOUNT);
                    } else {
                        nbFastAnswersLeft.set(msg.author.id, fastAnswersLeft - 1);
                    }
                }
            }

            lastAnswerTimestamp.set(msg.author.id, msgTimestamp);

            if (answer) {
                var content = StringTools.replace(msg.content, '@?everyone', '');

                for (mentionnedUser in msg.mentions.users.keyArray()) {
                    if (mentionnedUser == user.id) {
                        content = StringTools.replace(content, user.toString(), '');
                    } else {
                        var mentionnedUserInstance: User = msg.mentions.users.get(mentionnedUser);

                        content = StringTools.replace(content, mentionnedUserInstance.toString(), mentionnedUserInstance.username);
                        content = StringTools.replace(content, '<@!' + mentionnedUser + '>', mentionnedUserInstance.username);
                    }
                }

                for (mentionnedChannel in msg.mentions.channels.keyArray()) {
                    var mentionnedChannelInstance: GuildChannel = msg.mentions.channels.get(mentionnedChannel);
                    content = StringTools.replace(content, mentionnedChannelInstance.toString(), mentionnedChannelInstance.name);
                }

                for (mentionnedRole in msg.mentions.roles.keyArray()) {
                    var mentionnedRoleInstance: Role = msg.mentions.roles.get(mentionnedRole);
                    content = StringTools.replace(content, mentionnedRoleInstance.toString(), mentionnedRoleInstance.name);
                }

                content = StringTools.trim(~/\s{2,}/g.replace(content, ' '));

                cleverbot.ask(content, function (error: Dynamic, response: String) {
                    if (error == null || !error) {
                        var output: String = '';
                        var channel: TextChannel = cast msg.channel;

                        if (channel.type != ChannelType.DM) {
                            output = msg.author + ', ';
                        }

                        output += html5Entities.decode(response);

                        context.sendToChannel(output);
                    } else {
                        Logger.error(html5Entities.decode(response));
                    }
                });
            } else {
                Logger.error('Bot suspected, not replying anymore for now');
                NotificationBus.instance.cleverbotErrorBotSuspected.dispatch(context);
            }
        } else {
            Logger.error('Received direct message when not ready to answer');
            NotificationBus.instance.cleverbotErrorNotReady.dispatch(context);
        }
    }

    private function cleverbotPrepareHandler(error: Dynamic, sessionName: String): Void {
        if (error == null || !error) {
            ready = true;
            cleverbot.setNick(sessionName);
            Logger.info('Cleverbot ready! Session: ' + sessionName);
        } else {
            error = true;

            Logger.error('CleverbotIO failed to connect');
            Logger.exception(error);
        }
    }
}
