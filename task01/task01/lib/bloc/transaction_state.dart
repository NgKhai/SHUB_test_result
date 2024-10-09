import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class FileUploadedState extends TransactionState {
  final String fileName;

  FileUploadedState(this.fileName);

  @override
  List<Object?> get props => [fileName];
}

class TransactionUpdatedState extends TransactionState {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  TransactionUpdatedState({this.startTime, this.endTime});

  // CopyWith method to update state properties
  TransactionUpdatedState copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return TransactionUpdatedState(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  List<Object?> get props => [startTime, endTime];
}

class TransactionQuerySuccess extends TransactionState {
  final double totalAmount;

  TransactionQuerySuccess(num amount) : totalAmount = amount.toDouble();

  @override
  List<Object?> get props => [totalAmount];
}


class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}

