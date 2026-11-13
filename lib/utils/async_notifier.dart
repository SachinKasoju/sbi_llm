class AsyncState<T> {
  final bool isLoading;
  final String? error;
  final T? data;

  const AsyncState({
    this.isLoading = false,
    this.error,
    this.data,
  });

  AsyncState<T> copyWith({
    bool? isLoading,
    String? error,
    T? data,
  }) {
    return AsyncState<T>(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}
