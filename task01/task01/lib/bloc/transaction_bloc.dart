// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'transaction_event.dart';
// import 'transaction_state.dart';
//
// class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
//   final Dio dio;
//
//   TransactionBloc() : dio = Dio(), super(TransactionInitial()) {
//     // Use `on<Event>` to handle events instead of 'mapEventToState'
//     on<UploadFileEvent>(_handleUploadFile);
//     on<QueryTransactionEvent>(_handleQueryTransaction);
//   }
//
//   Future<void> _handleUploadFile(UploadFileEvent event, Emitter<TransactionState> emit) async {
//     emit(TransactionLoading());
//     try {
//       final formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(event.filePath),
//       });
//       await dio.post('http://localhost:3000/upload', data: formData);
//       emit(FileUploadedState());
//     } catch (e) {
//       emit(TransactionError("Error uploading file: ${e.toString()}"));
//     }
//   }
//
//   Future<void> _handleQueryTransaction(QueryTransactionEvent event, Emitter<TransactionState> emit) async {
//     emit(TransactionLoading());
//     try {
//       final response = await dio.get(
//         'http://localhost:3000/transactions',
//         queryParameters: {
//           'startTime': event.startTime,
//           'endTime': event.endTime,
//         },
//       );
//       final totalAmount = response.data['totalAmount'];
//       emit(TransactionQuerySuccess(totalAmount));
//     } on DioError catch (e) {
//       emit(TransactionError("Server error: ${e.response?.data['error'] ?? e.message}"));
//       print("DioError: ${e.response?.data ?? e.message}");
//     } catch (e) {
//       emit(TransactionError("Unexpected error: ${e.toString()}"));
//       print("Unexpected error: $e");
//     }
//   }
//
//
// }

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final Dio dio;

  TransactionBloc() : dio = Dio(), super(TransactionInitial()) {
    // Registering event handlers
    on<UploadFileEvent>(_handleUploadFile);
    on<QueryTransactionEvent>(_handleQueryTransaction);
    on<SelectStartTimeEvent>(_handleSelectStartTime);
    on<SelectEndTimeEvent>(_handleSelectEndTime);
  }

  // Handles file upload event
  Future<void> _handleUploadFile(UploadFileEvent event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(event.filePath),
      });
      await dio.post('http://localhost:3000/upload', data: formData);
      emit(FileUploadedState(event.filePath.split('/').last));
    } catch (e) {
      emit(TransactionError("Error uploading file: ${e.toString()}"));
    }
  }

  // Handles transaction query event
  Future<void> _handleQueryTransaction(QueryTransactionEvent event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final response = await dio.get(
        'http://localhost:3000/transactions',
        queryParameters: {
          'startTime': event.startTime,
          'endTime': event.endTime,
        },
      );
      final totalAmount = response.data['totalAmount'];
      emit(TransactionQuerySuccess(totalAmount));
    } on DioError catch (e) {
      emit(TransactionError("Server error: ${e.response?.data['error'] ?? e.message}"));
    } catch (e) {
      emit(TransactionError("Unexpected error: ${e.toString()}"));
    }
  }

  // Handle start time selection
  Future<void> _handleSelectStartTime(SelectStartTimeEvent event, Emitter<TransactionState> emit) async {
    final currentState = state;
    if (currentState is TransactionUpdatedState) {
      emit(currentState.copyWith(startTime: event.startTime));
    } else {
      emit(TransactionUpdatedState(startTime: event.startTime));
    }
  }

  // Handle end time selection
  Future<void> _handleSelectEndTime(SelectEndTimeEvent event, Emitter<TransactionState> emit) async {
    final currentState = state;
    if (currentState is TransactionUpdatedState) {
      emit(currentState.copyWith(endTime: event.endTime));
    } else {
      emit(TransactionUpdatedState(endTime: event.endTime));
    }
  }
}
