<!-- shared with plugins that use queues. -->
    - name: queue.max_batch_size
      type: number
      default: 1
      description: Maximum number of entries to be processed together
          as a batch.
          minimum_version: "3.3.x"
    - name: queue.max_coalescing_delay
      type: number
      default: 1
      description: >
          Maximum number of seconds (as a fraction) that can elapse
          after the first entry was queued before the queue starts
          processing entries.  This parameter has no effect when
          `batch_max_size` is one because queued entries will be sent
          immediately in that case.
          minimum_version: "3.3.x"
    - name: queue.max_entries
      type: number
      default: 10000
      description: >
          Maximum number of entries that can be waiting on the queue.
          Once this number of requests is reached, the oldest entry is
          deleted from the queue before a new one is added.
          minimum_version: "3.3.x"
    - name: queue.max_bytes
      type: number
      default: nil
      description:
          Maximum number of bytes that can be waiting on a queue.
          Once this many bytes are present on a queue, old entries
          up to the size of a new entry to be enqueued are deleted
          from the queue.
          minimum_version: "3.3.x"
    - name: queue.max_retry_time
      type: number
      default: 60
      description: >
          Time (in seconds) before the queue gives up trying to send a
          batch of entries.  Once this time is exceeded for a batch,
          it is deleted from the queue without being sent.  If
          this parameter is set to -1, no retries will be made for a
          failed batch.
          minimum_version: "3.3.x"
    - name: queue.max_retry_delay
      type: number
      default: 60
      description: >
          Maximum time (in seconds) between retries sending a batch of
          entries. The interval between retries follows an
          exponential back-off algorithm capped at this number of
          seconds.
          minimum_version: "3.3.x"
