package discordbothx.core;

import Type.ValueType;
import discordbothx.service.BaseCommand;
import discordbothx.external.nodejs.Object;
import nodejs.Process;
import discordhx.Collection;
import discordbothx.event.ProcessEventHandler;
import discordbothx.event.ClientEventHandler;
import js.Promise;
import discordhx.client.Client;
import discordbothx.log.Logger;
import nodejs.NodeJS;

class DiscordBot {
    public static var instance(get, null): DiscordBot;

    public var client: Client;

    // Configuration variables
    public var authDetails: IAuthDetailsProvider;
    public var permissionSystem: IPermissionSystem;
    public var commandIdentifier: String;
    public var chatInPrivate: Bool;
    public var handleHelpDialog: Bool;
    public var helpDialogHeader: CommunicationContext->String;
    public var helpDialogFooter: CommunicationContext->String;
    public var commands: Collection<String, Class<BaseCommand>>;

    public static function get_instance() {
        if (instance == null) {
            instance = new DiscordBot();
        }

        return instance;
    }

    private function new() {
        if (Type.typeof(Object.values) == ValueType.TNull) {
            Logger.error('You have to run this script with the --harmony flag: node --harmony yourscript.js');
            NodeJS.process.exit(1);
        } else {
            client = new Client();
            authDetails = null;
            configureDefaultValues();

            Logger.info('Application launched.');

            var clientEventHandler = new ClientEventHandler(client);
            var processEventHandler = new ProcessEventHandler(NodeJS.process);
        }
    }

    public function login(?authToken: String, ?authPassword: String): Promise<String> {
        var ret: Promise<String> = new Promise<String>(
            function (resolve: String->Void, reject: Dynamic->Void) {
                resolve(null);
            }
        );
        var token: String = authDetails.DISCORD_TOKEN;
        var password: String = authDetails.DISCORD_PASSWORD;

        if (authToken != null) {
            token = authToken;
        }

        if (authPassword != null) {
            password = authPassword;
        }

        if (token != null) {
            Logger.info('Logging in...');
            ret = client.login(token, password);
        } else {
            Logger.error('You have to provide at least a token in order to log in');
        }

        return ret;
    }

    private function configureDefaultValues() {
        var helpDialogHeaderFooter: CommunicationContext->String = function (context: CommunicationContext): String {
            return null;
        };

        permissionSystem = new DefaultPermissionSystem();
        commandIdentifier = '!';
        chatInPrivate = false;
        handleHelpDialog = true;
        helpDialogHeader = helpDialogHeaderFooter;
        helpDialogFooter = helpDialogHeaderFooter;
        commands = new Collection<String, Class<BaseCommand>>();
    }
}
