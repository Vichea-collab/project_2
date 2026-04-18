class BookingState {
  const BookingState({
    this.isConfirming = false,
    this.isPurchasingTicket = false,
    this.actionError,
  });

  final bool isConfirming;
  final bool isPurchasingTicket;
  final String? actionError;

  bool get isBusy => isConfirming || isPurchasingTicket;

  BookingState copyWith({
    bool? isConfirming,
    bool? isPurchasingTicket,
    Object? actionError = _sentinel,
  }) {
    return BookingState(
      isConfirming: isConfirming ?? this.isConfirming,
      isPurchasingTicket: isPurchasingTicket ?? this.isPurchasingTicket,
      actionError: identical(actionError, _sentinel)
          ? this.actionError
          : actionError as String?,
    );
  }
}

const _sentinel = Object();
