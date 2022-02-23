import { useAuthenticatedFunction, useSecret } from "./utils/security-utilities";
import { CustomUserData } from "./models/custom-user-data";
import { useUserCollection, useUserRecord } from "./utils/firestore-utilities";
import { config, https } from "firebase-functions";
import { CheckUsernameAvailabilityRequest } from "./models/check-username-availability-request";
import { SetTripRequest } from "./models/set-trip-request";
import { DeleteTripRequest } from "./models/delete-trip-request";
import { firestore, initializeApp } from "firebase-admin";
import { SetActivityRequest } from "./models/set-activity-request";
import { DeleteActivityRequest } from "./models/delete-activity-request";
import { SearchLocalityRequest } from "./models/search-locality-request";
import { SearchPlacesRequest } from "./models/search-places-request";
import { GetPlaceDetailsRequest } from "./models/get-place-details-request.ts";
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

    await ref.set({
        trips: {
            [tripId]: firestore.FieldValue.delete()
        }
    }, { merge: true });
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

    await ref.set({
        trips: {
            [tripId]: {
                activities: {
                    [activityId]: firestore.FieldValue.delete()
                }
            }
        }
    }, { merge: true });
});

export const searchLocalityProxy = useAuthenticatedFunction<SearchLocalityRequest>(async ({ input, sessionToken: sesstionToken }, _) => {
    const mapsKey = useSecret("MAPS_KEY");

    const requestUrl = new URL("https://maps.googleapis.com/maps/api/place/autocomplete/json");
    requestUrl.searchParams.append("key", mapsKey);
    requestUrl.searchParams.append("input", input);
    requestUrl.searchParams.append("sessiontoken", sesstionToken);
    requestUrl.searchParams.append("types", "(cities)");


    const response = await fetch(requestUrl.href);

    return await response.json();
});

export const searchPlaceProxy = useAuthenticatedFunction<SearchPlacesRequest>(async ({ input, locality }, _) => {
    const foursquareKey = useSecret("FOURSQUARE_KEY");

    const requestUrl = new URL("https://api.foursquare.com/v3/places/search");
    requestUrl.searchParams.append("query", input);
    requestUrl.searchParams.append("near", locality);
    requestUrl.searchParams.append("fields", "fsq_id,name,categories,photos");
    requestUrl.searchParams.append("sort", "popularity");


    const response = await fetch(requestUrl.href, {
        headers: {
            "Authorization": foursquareKey,
            "Accept": "application/json"
        }
    });

    return await response.json();
});

export const getPlaceDetailsProxy = useAuthenticatedFunction<GetPlaceDetailsRequest>(async ({ foursquareId }, _) => {
    const foursquareKey = useSecret("FOURSQUARE_KEY");

    const requestUrl = new URL(`https://api.foursquare.com/v3/places/${foursquareId}`);
    requestUrl.searchParams.append("fields", "fsq_id,name,categories,photos,description,tel,website,social_media,hours,hours_popular,rating,price");


    const response = await fetch(requestUrl.href, {
        headers: {
            "Authorization": foursquareKey,
            "Accept": "application/json"
        }
    });

    return await response.json();
});