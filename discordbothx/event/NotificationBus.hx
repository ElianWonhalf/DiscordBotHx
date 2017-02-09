package discordbothx.event;

import discordbothx.core.CommunicationContext;
import msignal.Signal.Signal0;
import msignal.Signal.Signal1;
import msignal.Signal.Signal2;

class NotificationBus {
    public static var instance(get, null): NotificationBus;

    public var cleverbotErrorNotReady: Signal0;
    public var cleverbotErrorBotSuspected: Signal0;
    public var chatInPrivate: Signal1<CommunicationContext>;
    public var checkPermissionError: Signal2<CommunicationContext, String>;
    public var getDeniedCommandListError: Signal1<CommunicationContext>;
    public var unknownCommand: Signal2<CommunicationContext, String>;
    public var noLastCommand: Signal1<CommunicationContext>;
    public var unauthorizedCommand: Signal2<CommunicationContext, String>;
    public var helpDialogSent: Signal1<CommunicationContext>;
    public var sendHelpDialogError: Signal1<CommunicationContext>;

    public static function get_instance() {
        if (instance == null) {
            instance = new NotificationBus();
        }

        return instance;
    }

    private function new() {
        cleverbotErrorNotReady = new Signal0();
        cleverbotErrorBotSuspected = new Signal0();
        chatInPrivate = new Signal1<CommunicationContext>();
        checkPermissionError = new Signal2<CommunicationContext, String>();
        getDeniedCommandListError = new Signal1<CommunicationContext>();
        unknownCommand = new Signal2<CommunicationContext, String>();
        noLastCommand = new Signal1<CommunicationContext>();
        unauthorizedCommand = new Signal2<CommunicationContext, String>();
        helpDialogSent = new Signal1<CommunicationContext>();
        sendHelpDialogError = new Signal1<CommunicationContext>();
    }
}
