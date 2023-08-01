export function sortBy (key, order, type) {
  return (a, b) => {
    if (type === 'number') {
      return sortByNumber(key, order)(a, b)
    } else if (type === 'date') {
      return sortByDate(key, order)(a, b)
    } else {
      return sortByString(key, order)(a, b)
    }
  }
}

export function sortByString (key, order = 'asc') {
  return (a, b) => {
    const aValue = a[key].toLowerCase()
    const bValue = b[key].toLowerCase()

    if (aValue === bValue) {
      return 0
    }

    if (order === 'asc') {
      return aValue > bValue ? 1 : -1
    }

    return aValue < bValue ? 1 : -1
  }
}

export function sortByNumber (key, order = 'asc') {
  return (a, b) => {
    const aValue = a[key]
    const bValue = b[key]

    if (aValue === bValue) {
      return 0
    }

    if (order === 'asc') {
      return aValue > bValue ? 1 : -1
    }

    return aValue < bValue ? 1 : -1
  }
}

export function sortByDate (key, order = 'asc') {
  return (a, b) => {
    const aValue = new Date(a[key]).getTime()
    const bValue = new Date(b[key]).getTime()

    if (aValue === bValue) {
      return 0
    }

    if (order === 'asc') {
      return aValue > bValue ? 1 : -1
    }

    return aValue < bValue ? 1 : -1
  }
}
