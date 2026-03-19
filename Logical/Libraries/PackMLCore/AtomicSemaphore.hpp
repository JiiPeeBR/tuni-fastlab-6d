#ifndef __ATOMIC_SEMAPHORE_HPP__
#define __ATOMIC_SEMAPHORE_HPP__

#include <atomic>


class AtomicSemaphore {
	std::atomic<bool> flag_;
	public:

	bool acquire() {
		return !std::atomic_exchange_explicit(&flag_, true, std::memory_order_acquire);
	}

	void release() {
		std::atomic_store_explicit(&flag_, false, std::memory_order_release);
	}

	bool occupied() {
		return flag_.load();
	}

	AtomicSemaphore(const AtomicSemaphore& source) {
		flag_.store(source.flag_.load());
	}

	AtomicSemaphore& operator=(const AtomicSemaphore& source) {
		flag_.store(source.flag_.load());
		return *this;
	}

	AtomicSemaphore() {
		flag_.store(false);
	}
};



#endif