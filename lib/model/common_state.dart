class CommonState {
  final bool isLoad;
  final bool isSuccess;
  final bool isError;
  final String errMessage;

  CommonState(
      {required this.errMessage,
      required this.isError,
      required this.isLoad,
      required this.isSuccess});

  CommonState copyWith(
      {bool? isLoad, bool? isSuccess, bool? isError, String? errMessage}) {
    return CommonState(
        errMessage: errMessage ?? this.errMessage,
        isError: isError ?? this.isSuccess,
        isLoad: isLoad ?? this.isLoad,
        isSuccess: isSuccess ?? this.isSuccess);
  }
}
