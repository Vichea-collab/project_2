import '../../../../utils/async_value.dart';

class BookingState {
  const BookingState({
    this.confirmValue = const AsyncValue.success(null),
    this.purchaseTicketValue = const AsyncValue.success(null),
  });

  final AsyncValue<void> confirmValue;
  final AsyncValue<void> purchaseTicketValue;

  bool get isConfirming => confirmValue.isLoading;
  bool get isPurchasingTicket => purchaseTicketValue.isLoading;
  bool get isBusy => isConfirming || isPurchasingTicket;
  String? get actionError => confirmValue.hasError
      ? confirmValue.errorMessage
      : (purchaseTicketValue.hasError
            ? purchaseTicketValue.errorMessage
            : null);

  BookingState copyWith({
    AsyncValue<void>? confirmValue,
    AsyncValue<void>? purchaseTicketValue,
  }) {
    return BookingState(
      confirmValue: confirmValue ?? this.confirmValue,
      purchaseTicketValue: purchaseTicketValue ?? this.purchaseTicketValue,
    );
  }
}
