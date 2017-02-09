package discordbothx.core;

import js.Promise;

class DefaultPermissionSystem implements IPermissionSystem {
    public function new() {}

    public function check(context: CommunicationContext, command: String): Promise<Bool> {
        return new Promise<Bool>(function (resolve: Bool->Void, reject: Dynamic->Void): Void {
            resolve(true);
        });
    }

    public function getDeniedCommandList(context: CommunicationContext): Promise<Array<String>> {
        return new Promise<Array<String>>(function (resolve: Array<String>->Void, reject: Dynamic->Void): Void {
            resolve(new Array<String>());
        });
    }
}
