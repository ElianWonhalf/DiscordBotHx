package discordbothx.core;

import discordhx.RichEmbed;
import discordbothx.core.CommunicationContext.SendableChannel;
import js.Error;
import discordbothx.core.CommunicationContext.SendableChannel;
import discordbothx.service.DiscordUtils;
import discordhx.BufferResolvable;
import discordhx.message.MessageOptions;
import discordhx.StringResolvable;
import discordhx.user.User;
import haxe.extern.EitherType;
import js.Promise;
import discordbothx.log.Logger;
import discordhx.channel.TextChannel;
import discordhx.message.Message;
import discordhx.client.Client;

class CommunicationContext {
    private static inline var MAX_RETRIES = 30;

    public var message(get, null): Message;

    private var client: Client;
    private var ownerUser: User;
    private var retriesLeft: Int;

    public function new(?msg: Message) {
        message = msg;
        client = DiscordBot.instance.client;
        ownerUser = DiscordBot.instance.client.users.get(DiscordBot.instance.authDetails.BOT_OWNER_ID);
        retriesLeft = MAX_RETRIES;
    }

    public function get_message(): Message {
        return message;
    }

    public function reply(text: String): Promise<Message> {
        return sendToChannel(text);
    }

    public function sendToChannel(text: String, ?options: MessageOptions): Promise<Message> {
        return sendMessage(cast message.channel, text, options);
    }

    public function sendToAuthor(text: String, ?options: MessageOptions): Promise<Message> {
        return sendMessage(cast message.author, text, options);
    }

    public function sendToOwner(text: String, ?options: MessageOptions): Promise<Message> {
        return sendMessage(cast ownerUser, text, options);
    }

    public function sendTo(destination: SendableChannel, text: String, ?options: MessageOptions): Promise<Message> {
        return sendMessage(destination, text, options);
    }

    public function sendCodeToChannel(lang: String, content: StringResolvable, ?options: MessageOptions): Promise<Message> {
        return sendCode(cast message.channel, lang, content, options);
    }

    public function sendCodeToAuthor(lang: String, content: StringResolvable, ?options: MessageOptions): Promise<Message> {
        return sendCode(cast message.author, lang, content, options);
    }

    public function sendCodeToOwner(lang: String, content: StringResolvable, ?options: MessageOptions): Promise<Message> {
        return sendCode(cast ownerUser, lang, content, options);
    }

    public function sendCodeTo(destination: SendableChannel, lang: String, content: StringResolvable, ?options: MessageOptions): Promise<Message> {
        return sendCode(destination, lang, content, options);
    }

    public function sendEmbedToChannel(embed: EitherType<RichEmbed, Dynamic>, ?content: String, ?options: MessageOptions): Promise<Message> {
        return sendEmbed(cast message.channel, embed, content, options);
    }

    public function sendEmbedToAuthor(embed: EitherType<RichEmbed, Dynamic>, ?content: String, ?options: MessageOptions): Promise<Message> {
        return sendEmbed(cast message.author, embed, content, options);
    }

    public function sendEmbedToOwner(embed: EitherType<RichEmbed, Dynamic>, ?content: String, ?options: MessageOptions): Promise<Message> {
        return sendEmbed(cast ownerUser, embed, content, options);
    }

    public function sendEmbedTo(destination: SendableChannel, embed: EitherType<RichEmbed, Dynamic>, ?content: String, ?options: MessageOptions): Promise<Message> {
        return sendEmbed(destination, embed, content, options);
    }

    public function sendFileToChannel(url: String, name: String, ?content: StringResolvable, ?options: MessageOptions): Promise<Message> {
        return sendFile(cast message.channel, url, name, content, options);
    }

    public function sendFileToAuthor(url: String, name: String, ?content: StringResolvable, ?options: MessageOptions): Promise<Message> {
        return sendFile(cast message.author, url, name, content, options);
    }

    public function sendFileToOwner(url: String, name: String, ?content: StringResolvable, ?options: MessageOptions): Promise<Message> {
        return sendFile(cast ownerUser, url, name, content, options);
    }

    public function sendFileTo(destination: SendableChannel, url: String, name: String, ?content: StringResolvable, ?options: MessageOptions): Promise<Message> {
        return sendFile(destination, url, name, content, options);
    }

    private function sendMessage(destination: SendableChannel, content: String, ?options: MessageOptions): Promise<Message> {
        var ret: Promise<Message> = null;

        if (content.length > DiscordUtils.MESSAGE_MAX_LENGTH) {
            var errorMessage: String = 'Content is longer than ' + DiscordUtils.MESSAGE_MAX_LENGTH + ' characters, cannot send the message';
            Logger.error(errorMessage);

            ret = new Promise<Message>(function (resolve: Message->Void, reject: Dynamic): Void {
                reject(new Error(errorMessage));
            });
        } else {
            ret = trySendingMessage(destination, content, options);
        }

        return ret;
    }

    private function trySendingMessage(destination: SendableChannel, content: String, ?options: MessageOptions): Promise<Message> {
        return new Promise<Message>(function (resolve: Message->Void, reject: Dynamic->Void) {
            destination.sendMessage(content, options).then(cast function (msg: Message): Void {
                if (retriesLeft < MAX_RETRIES) {
                    Logger.info('Message successfully sent after retries');
                }

                retriesLeft = MAX_RETRIES;
                resolve(msg);
            }).catchError(function (err: Dynamic) {
                if (retriesLeft > 0) {
                    Logger.error('Message not sent, retrying...');
                    Logger.exception(err.response.body.message);
                    retriesLeft--;

                    trySendingMessage(destination, content);
                } else {
                    Logger.error('Could not send message, giving up');
                    Logger.exception(err.response.body.message);

                    retriesLeft = MAX_RETRIES;
                    reject(err);
                }
            });
        });
    }

    private function sendCode(destination: SendableChannel, lang: String, content: StringResolvable, ?options: MessageOptions): Promise<Message> {
        return destination.sendCode(lang, content, options);
    }

    private function sendEmbed(destination: SendableChannel, embed: EitherType<RichEmbed, Dynamic>, ?content: String, ?options: MessageOptions): Promise<Message> {
        return destination.sendEmbed(embed, content, options);
    }

    private function sendFile(destination: SendableChannel, url: String, name: String, ?content: StringResolvable, ?options: MessageOptions): Promise<Message> {
        return destination.sendFile(url, name, content, options);
    }
}

typedef SendableChannel = {
    public function sendMessage(content: StringResolvable, ?options: MessageOptions): Promise<EitherType<Message, Array<Message>>>;
    public function sendCode(lang: String, content: StringResolvable, ?options: MessageOptions): Promise<EitherType<Message, Array<Message>>>;
    public function sendEmbed(embed: EitherType<RichEmbed, Dynamic>, ?content: String, ?options: MessageOptions): Promise<Message>;
    public function sendFile(attachment: BufferResolvable, ?fileName: String, ?content: StringResolvable, ?options: MessageOptions): Promise<Message>;
};
