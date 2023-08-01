import { ToastManager } from '@kong/kongponents'

// Initialize the ToastManager as a singleton so a new instance isn't created each time
const toaster = new ToastManager()

export default function useToaster () {
  const notify = async (notification) => {
    const defaultConfig = {
      appearance: 'success',
      message: 'Success',
      timeoutMilliseconds: 3000
    }

    toaster.open({
      ...defaultConfig,
      ...notification
    })
  }

  return {
    notify
  }
}
