export interface SearchPlacesRequest {
    input: string;
    locality: string;
    category?: number;
}