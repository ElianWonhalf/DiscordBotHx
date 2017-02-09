package discordbothx.core;

import js.Promise;

interface IPermissionSystem {
    public function check(context: CommunicationContext, command: String): Promise<Bool>;
    public function getDeniedCommandList(context: CommunicationContext): Promise<Array<String>>;
}
