import * as functions from "firebase-functions";
import { AuthData } from "firebase-functions/lib/common/providers/https";

export function useCallableFunction<TPayload>(functionHandler: (payload: TPayload, currentUser: AuthData | undefined) => unknown) {
    return functions
        .region("europe-west6")
        .https
        .onCall((data, context) => {
            functions.logger.info({ data });
            return functionHandler(data, context.auth);
        });
}