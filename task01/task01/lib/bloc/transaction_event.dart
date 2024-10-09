import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadFileEvent extends TransactionEvent {
  final String filePath;
  UploadFileEvent(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class SelectStartTimeEvent extends TransactionEvent {
  final TimeOfDay startTime;

  SelectStartTimeEvent(this.startTime);

  @override
  List<Object?> get props => [startTime];
}

class SelectEndTimeEvent extends TransactionEvent {
  final TimeOfDay endTime;

  SelectEndTimeEvent(this.endTime);

  @override
  List<Object?> get props => [endTime];
}

class QueryTransactionEvent extends TransactionEvent {
  final String startTime;
  final String endTime;

  QueryTransactionEvent(this.startTime, this.endTime);

  @override
  List<Object?> get props => [startTime, endTime];
}
