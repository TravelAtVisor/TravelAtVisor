import { Activity } from "./activity";

export interface Trip {
    title: string;
    begin: string;
    end: string;
    companions: string[];
    activities: { [activityId: string]: Activity };
}
