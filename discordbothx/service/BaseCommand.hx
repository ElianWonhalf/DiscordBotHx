package discordbothx.service;

import discordbothx.core.CommunicationContext;

class BaseCommand {
    private var context: CommunicationContext;

    public function new(context: CommunicationContext): Void {
        this.context = context;
    }
}
