import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  String transactionResult = '';
  String fileUpload = '';

  // Format TimeOfDay to HH:mm:ss string format
  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final formattedTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return "${formattedTime.hour.toString().padLeft(2, '0')}:${formattedTime.minute.toString().padLeft(2, '0')}:00";
  }

  // Format number as Vietnamese currency
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  Future<void> pickStartTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      BlocProvider.of<TransactionBloc>(context).add(SelectStartTimeEvent(time));
    }
  }

  Future<void> pickEndTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      BlocProvider.of<TransactionBloc>(context).add(SelectEndTimeEvent(time));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Transactions'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          TimeOfDay? startTime;
          TimeOfDay? endTime;

          if (state is FileUploadedState) {
            fileUpload = state.fileName;
          } else if (state is TransactionUpdatedState) {
            startTime = state.startTime;
            endTime = state.endTime;
          } else if (state is TransactionQuerySuccess) {
            transactionResult = 'Total Amount from ${formatTimeOfDay(startTime)} to ${formatTimeOfDay(endTime)}: '
                '${formatCurrency(state.totalAmount)}';
          } else if (state is TransactionError) {
            transactionResult = '❌ Error: ${state.message}';
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx'],
                      );
                      if (result != null) {
                        BlocProvider.of<TransactionBloc>(context)
                            .add(UploadFileEvent(result.files.single.path!));
                      }
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload File'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (fileUpload.isNotEmpty)
                  Center(
                    child: Text(
                      fileUpload,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => pickStartTime(context),
                        child: Text(startTime == null
                            ? 'Pick Start Time'
                            : 'Start Time: ${formatTimeOfDay(startTime)}'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => pickEndTime(context),
                        child: Text(endTime == null
                            ? 'Pick End Time'
                            : 'End Time: ${formatTimeOfDay(endTime)}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (startTime != null && endTime != null) {
                        BlocProvider.of<TransactionBloc>(context).add(
                          QueryTransactionEvent(
                            formatTimeOfDay(startTime),
                            formatTimeOfDay(endTime),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select both start and end times'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('Query Transactions'),
                  ),
                ),
                const SizedBox(height: 20),
                if (transactionResult.isNotEmpty)
                  Center(
                    child: Text(
                      transactionResult,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
