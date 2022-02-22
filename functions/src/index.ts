import { useAuthenticatedFunction } from "./utils/authentication-utilities";
import { CustomUserData } from "./models/custom-user-data";
import { useUserCollection, useUserRecord } from "./utils/firestore-utilities";
import { config, https } from "firebase-functions";
import { CheckUsernameAvailabilityRequest } from "./models/check-username-availability-request";
import { SetTripRequest } from "./models/set-trip-request";
import { DeleteTripRequest } from "./models/delete-trip-request";
import { firestore, initializeApp } from "firebase-admin";
import { SetActivityRequest } from "./models/set-activity-request";
import { DeleteActivityRequest } from "./models/delete-activity-request";
initializeApp(config().firebase);


export const getCustomUserData = useAuthenticatedFunction<void>(async (_, { uid }) => {
    const snapshot = await useUserRecord(uid).get();

    return snapshot.data();
});

export const updateCustomUserData = useAuthenticatedFunction<CustomUserData>((userData, { uid }) => {
    const ref = useUserRecord(uid);
    return ref.set(userData);
});

export const isUsernameAvailable = https.onCall(async ({ username }: CheckUsernameAvailabilityRequest, _) => {
    const userCollection = useUserCollection();

    const snapshot = await userCollection
        .where("nickname", "==", username)
        .get()

    return snapshot.size === 0;
});

export const setTrip = useAuthenticatedFunction<SetTripRequest>(async ({ trip, tripId }, { uid }) => {
    const ref = useUserRecord(uid);

    await ref.set({
        trips: {
            [tripId]: trip
        }
    } as Partial<CustomUserData>, { merge: true });
});

export const deleteTrip = useAuthenticatedFunction<DeleteTripRequest>(async ({ tripId }, { uid }) => {
    const ref = useUserRecord(uid);

    await ref.update({
        trips: {
            [tripId]: firestore.FieldValue.delete()
        }
    });
});

export const setActivity = useAuthenticatedFunction<SetActivityRequest>(async ({ activity, activityId, tripId }, { uid }) => {
    const ref = useUserRecord(uid);

    await ref.set({
        trips: {
            [tripId]: {
                activities: {
                    [activityId]: activity
                }
            }
        }
    } as Partial<CustomUserData>, { merge: true });
});

export const deleteActivity = useAuthenticatedFunction<DeleteActivityRequest>(async ({ tripId, activityId }, { uid }) => {
    const ref = useUserRecord(uid);

    await ref.update({
        trips: {
            [tripId]: {
                activities: {
                    [activityId]: firestore.FieldValue.delete()
                }
            }
        }
    });
});