import { https, logger, config } from "firebase-functions";
import { AuthData } from "firebase-functions/lib/common/providers/https";
import { useCallableFunction } from "./functions-utilities";

export function useAuthenticatedFunction<TPayload>(guardedHandler: (payload: TPayload, currentUser: AuthData) => unknown) {
    return useCallableFunction<TPayload>((data, currentUser) => {
        const isAuthenticated = currentUser?.uid !== null;

        if (!isAuthenticated) {
            logger.info("An unauthenticated call to a cloud function was prohibited to execute");

            throw new https.HttpsError("unauthenticated", "You must be authenticated to call this function");
        }

        return guardedHandler(data as TPayload, currentUser!);
    });
}

export const useSecret = (secretName: string) => {
    const value = config().keys[secretName];

    if (value === undefined) {
        throw new https.HttpsError("internal", "Unkown secret", { secretName });
    }

    return value;
};