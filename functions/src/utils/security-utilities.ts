import { https, logger } from "firebase-functions";
import { AuthData } from "firebase-functions/lib/common/providers/https";

export function useAuthenticatedFunction<TPayload>(guardedHandler: (payload: TPayload, currentUser: AuthData) => unknown) {
    return https.onCall((data, context) => {
        const isAuthenticated = context.auth?.uid !== null;

        if (!isAuthenticated) {
            logger.info("An unauthenticated call to a cloud function was prohibited to execute");

            throw new https.HttpsError("unauthenticated", "You must be authenticated to call any of our cloud functions");
        }

        return guardedHandler(data as TPayload, context.auth!);
    });
}

export const useSecret = (secretName: string) => {
    const value = process.env[secretName];

    if (value === undefined) {
        throw new https.HttpsError("internal", "Unkown secret", { secretName });
    }

    return value;
};