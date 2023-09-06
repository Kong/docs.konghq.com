export async function fetchAll (fn) {
  const meta = {
    pageSize: 100,
    pageNumber: 1
  }

  const { data } = await fn(meta)
  const results = [...data.data]

  while (results.length <= data?.meta?.total) {
    meta.pageNumber++
    const { data: newData } = await fn(meta)

    results.push(...newData.data)
  }

  return results
}
