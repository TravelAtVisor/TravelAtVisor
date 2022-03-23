import { Trip } from "./trip";

export interface CustomUserData {
    nickname: string;
    fullName: string;
    photoUrl?: string;
    biography?: string;
    trips: { [tripId: string]: Trip };
    friends: string[];
}
