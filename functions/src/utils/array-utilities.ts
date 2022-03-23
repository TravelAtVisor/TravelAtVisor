export async function useBatchedEffect<TInput, TResult>(
    source: TInput[],
    batchSize: number,
    effect: (batch: TInput[]) => Promise<TResult[]>,
): Promise<TResult[]> {
    const batches: TInput[][] = [];
    source.forEach((item, index) => {
        const batchIndex = Math.floor(index / batchSize);
        const currentBatch = batches[batchIndex] ?? [];
        batches[batchIndex] = [
            ...currentBatch,
            item
        ];
    });

    const promises = batches.map(batch => effect(batch));
    const subResults = await Promise.all(promises);
    return subResults.flat();
}