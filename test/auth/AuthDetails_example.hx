package test.auth;

import discordbothx.core.IAuthDetailsProvider;

class AuthDetails_example implements IAuthDetailsProvider {
    public var BOT_OWNER_ID = '';

    public var DISCORD_TOKEN = '';
    public var DISCORD_PASSWORD = '';

    public var CLEVERBOTIO_USER = '';
    public var CLEVERBOTIO_KEY = '';

    public function new() {}
}
