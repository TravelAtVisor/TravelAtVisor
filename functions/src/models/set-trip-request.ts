import { Trip } from "./trip";

export interface SetTripRequest {
    tripId: string;
    trip: Trip;
}