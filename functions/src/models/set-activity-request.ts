import { Activity } from "./activity";

export interface SetActivityRequest {
    tripId: string;
    activityId: string;
    activity: Activity;
}