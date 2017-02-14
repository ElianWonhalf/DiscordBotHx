package test.service;

import js.Promise;
import discordbothx.core.DiscordBot;
import discordbothx.core.CommunicationContext;
import discordbothx.core.IPermissionSystem;

class PermissionSystem implements IPermissionSystem {
    public function new() {}

    public function check(context: CommunicationContext, command: String): Promise<Bool> {
        return new Promise<Bool>(function (resolve: Bool->Void, reject: Dynamic->Void): Void {
            var granted: Bool = false;

            switch (command.toLowerCase()) {
                case 'kick':
                    granted = context.message.author.id == DiscordBot.instance.authDetails.BOT_OWNER_ID;

                default:
                    granted = true;
            }

            resolve(granted);
        });
    }

    public function getDeniedCommandList(context: CommunicationContext): Promise<Array<String>> {
        return new Promise<Array<String>>(function (resolve: Array<String>->Void, reject: Dynamic->Void): Void {
            var list: Array<String> = [];

            if (context.message.author.id != DiscordBot.instance.authDetails.BOT_OWNER_ID) {
                list.push('kick');
            }

            resolve(list);
        });
    }
}
