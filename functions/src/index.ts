import { useAuthenticatedFunction, useSecret } from "./utils/security-utilities";
import { CustomUserData } from "./models/custom-user-data";
import { useUserCollection, useUserRecord } from "./utils/firestore-utilities";
import { config, https } from "firebase-functions";
import { CheckUsernameAvailabilityRequest } from "./models/check-username-availability-request";
import { SetTripRequest } from "./models/set-trip-request";
import { DeleteTripRequest } from "./models/delete-trip-request";
import { firestore, initializeApp } from "firebase-admin";
import { SetActivityRequest as AddActivityRequest } from "./models/add-activity-request";
import { DeleteActivityRequest } from "./models/delete-activity-request";
import { SearchLocalityRequest } from "./models/search-locality-request";
import { SearchPlacesRequest } from "./models/search-places-request";
import { GetPlaceDetailsRequest } from "./models/get-place-details-request.ts";
import { useCallableFunction } from "./utils/functions-utilities";
import axios from 'axios';
import { ModifyFriendshipRequest } from "./models/modify-friendship-request";
import { ModifyTripFriendRequest } from "./models/modify-trip-friends-request";
import { GetForeignProfileRequest } from "./models/get-foreign-profile-request";
import { SearchUserRequest } from "./models/search-user-request";
import { UserSuggestion } from "./models/user-suggestion";
import { GetFriendsRequest } from "./models/get-friends-request";

initializeApp(config().firebase);


export const getCustomUserData = useAuthenticatedFunction<void>(async (_, { uid }) => {
    const snapshot = await useUserRecord(uid).get();

    return snapshot.data();
});

export const updateCustomUserData = useAuthenticatedFunction<CustomUserData>((userData, { uid }) => {
    const ref = useUserRecord(uid);
    return ref.set(userData);
});

export const isUsernameAvailable = useCallableFunction<CheckUsernameAvailabilityRequest>(async ({ username }, authentication) => {
    const userCollection = useUserCollection();
    const callingUserId = authentication?.uid;
    const snapshot = await userCollection
        .where("nickname", "==", username).get();

    let isValid = true;
    snapshot.forEach((document) => {
        isValid = isValid && document.id === callingUserId;
    });

    return isValid;
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

export const addActivity = useAuthenticatedFunction<AddActivityRequest>(async ({ activity, activityId, tripId }, { uid }) => {
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
    const mapsKey = useSecret("maps");

    const requestUrl = new URL("https://maps.googleapis.com/maps/api/place/autocomplete/json");
    requestUrl.searchParams.append("key", mapsKey);
    requestUrl.searchParams.append("input", input);
    requestUrl.searchParams.append("sessiontoken", sesstionToken);
    requestUrl.searchParams.append("types", "(cities)");


    const response = await axios.get(requestUrl.href);

    return await response.data;
});

export const searchPlaceProxy = useAuthenticatedFunction<SearchPlacesRequest>(async ({ input, locality, category }, _) => {
    const foursquareKey = useSecret("foursquare");

    const requestUrl = new URL("https://api.foursquare.com/v3/places/search");
    requestUrl.searchParams.append("query", input);
    requestUrl.searchParams.append("near", locality);
    requestUrl.searchParams.append("fields", "fsq_id,name,categories,photos");
    requestUrl.searchParams.append("sort", "popularity");
    if (category !== null) requestUrl.searchParams.append("categories", `${category}`);

    const response = await axios.get(requestUrl.href, {
        headers: {
            "Authorization": foursquareKey,
            "Accept": "application/json"
        }
    });

    return await response.data;
});

export const getPlaceDetailsProxy = useAuthenticatedFunction<GetPlaceDetailsRequest>(async ({ foursquareId }, _) => {
    const foursquareKey = useSecret("foursquare");

    const requestUrl = new URL(`https://api.foursquare.com/v3/places/${foursquareId}`);
    requestUrl.searchParams.append("fields", "fsq_id,name,categories,photos,description,tel,website,social_media,hours,hours_popular,rating,price,location,geocodes");

    const response = await axios.get(requestUrl.href, {
        headers: {
            "Authorization": foursquareKey,
            "Accept": "application/json"
        }
    });

    return await response.data;
});

export const addFriend = useAuthenticatedFunction<ModifyFriendshipRequest>(async ({ friendUserId }, { uid }) => {
    const ref = useUserRecord(uid);

    await ref.set({
        friends: firestore.FieldValue.arrayUnion(friendUserId)
    }, { merge: true });
});

export const removeFriend = useAuthenticatedFunction<ModifyFriendshipRequest>(async ({ friendUserId }, { uid }) => {
    const ref = useUserRecord(uid);

    await ref.set({
        friends: firestore.FieldValue.arrayRemove(friendUserId)
    }, { merge: true });
});

export const addFriendToTrip = useAuthenticatedFunction<ModifyTripFriendRequest>(async ({ friendUserId, tripId }, { uid }) => {
    const ref = useUserRecord(uid);

    await ref.set({
        trips: {
            [tripId]: {
                companions: firestore.FieldValue.arrayUnion(friendUserId)
            }
        }
    }, { merge: true });
});

export const removeFriendFromTrip = useAuthenticatedFunction<ModifyTripFriendRequest>(async ({ friendUserId, tripId }, { uid }) => {
    const ref = useUserRecord(uid);

    await ref.set({
        trips: {
            [tripId]: {
                companions: firestore.FieldValue.arrayRemove(friendUserId),
            }
        }
    }, { merge: true });
});

export const getForeignProfile = useAuthenticatedFunction<GetForeignProfileRequest>(async ({ foreignUserId }, _) => {
    const ref = useUserRecord(foreignUserId);

    const profile = await ref.get();

    if (!profile.exists) {
        throw new https.HttpsError("not-found", "The specified user id does not exist.", { foreignUserId });
    }

    return profile.data();
});

export const searchUsers = useAuthenticatedFunction<SearchUserRequest>(async ({ query }, { uid }) => {
    const userCollection = useUserCollection();

    const snapshot = await userCollection.get();

    const allUsers = snapshot
        .docs
        .reduce((accumulator, data) => {
            const profile = data.data() as CustomUserData;

            const searchableFields = [profile.fullName, profile.nickname];

            if (searchableFields.some(f => f.includes(query))) {

                return {
                    ...accumulator,
                    [data.id]: {
                        photoUrl: profile.photoUrl,
                        userId: data.id,
                        userName: profile.nickname,
                        fullName: profile.fullName,
                    } as UserSuggestion
                };
            }

            return accumulator;

        }, {} as { [userId: string]: UserSuggestion });

    return Object.values(allUsers);
});

export const getFriends = useAuthenticatedFunction<GetFriendsRequest>(async ({ friendIds }, _) => {
    if (friendIds.length == 0) return [];

    const userCollection = useUserCollection();

    const friends = await userCollection
        .where(firestore.FieldPath.documentId(), "in", friendIds)
        .get();

    return friends.docs.map(doc => {
        const { fullName, nickname, photoUrl } = doc.data();

        return {
            userId: doc.id,
            fullName,
            userName: nickname,
            photoUrl,
        } as UserSuggestion;
    });
});