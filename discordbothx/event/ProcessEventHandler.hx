package discordbothx.event;

import discordbothx.core.DiscordBot;
import discordbothx.log.Logger;
import nodejs.NodeJS;
import nodejs.Process;

class ProcessEventHandler extends EventHandler<Process> {
    private override function process(): Void {
        _eventEmitter.on(ProcessEvent.UNCAUGHT_EXCEPTION, uncaughtExceptionHandler);
        _eventEmitter.on(ProcessEvent.SIGINT, signalInterruptionHandler);
    }

    private function uncaughtExceptionHandler(e: Dynamic) {
        Logger.exception(e.stack);

        DiscordBot.instance.client.destroy().then(cast function () {
            DiscordBot.instance.login();
        });
    }

    private function signalInterruptionHandler() {
        DiscordBot.instance.client.destroy().then(cast function () {
            Logger.end();
            NodeJS.process.exit(0);
        });
    }
}
