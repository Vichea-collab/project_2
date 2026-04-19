enum AsyncValueState { loading, success, error }

class AsyncValue<T> {
  const AsyncValue._({required this.state, this.data, this.error});

  const AsyncValue.loading() : this._(state: AsyncValueState.loading);

  const AsyncValue.success(T? data)
    : this._(state: AsyncValueState.success, data: data);

  const AsyncValue.error(Object error)
    : this._(state: AsyncValueState.error, error: error);

  final AsyncValueState state;
  final T? data;
  final Object? error;

  bool get isLoading => state == AsyncValueState.loading;
  bool get isSuccess => state == AsyncValueState.success;
  bool get hasError => state == AsyncValueState.error;

  String? get errorMessage => error?.toString();
}
