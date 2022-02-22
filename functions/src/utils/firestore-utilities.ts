import { firestore } from "firebase-admin";


export const useUserCollection = () => firestore()
    .collection("users");
export const useUserRecord = (uid: string) => useUserCollection()
    .doc(uid);