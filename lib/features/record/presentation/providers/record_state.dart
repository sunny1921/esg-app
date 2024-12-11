import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_state.freezed.dart';

@freezed
class BillState with _$BillState {
  const factory BillState({
    @Default(false) bool isProcessing,
    @Default(false) bool isUploading,
    @Default(null) Map<String, dynamic>? billData,
    @Default(null) String? error,
  }) = _BillState;
}

final electricityBillProvider =
    StateNotifierProvider<BillStateNotifier, BillState>(
  (ref) => BillStateNotifier(),
);

final waterBillProvider = StateNotifierProvider<BillStateNotifier, BillState>(
  (ref) => BillStateNotifier(),
);

final fuelBillProvider = StateNotifierProvider<BillStateNotifier, BillState>(
  (ref) => BillStateNotifier(),
);

class BillStateNotifier extends StateNotifier<BillState> {
  BillStateNotifier() : super(const BillState());

  void setLoading(bool loading) {
    state = state.copyWith(isProcessing: loading);
  }

  void setBillData(Map<String, dynamic>? data) {
    state = state.copyWith(billData: data, error: null);
  }

  void setError(String? error) {
    state = state.copyWith(error: error, billData: null);
  }

  void reset() {
    state = const BillState();
  }
}
