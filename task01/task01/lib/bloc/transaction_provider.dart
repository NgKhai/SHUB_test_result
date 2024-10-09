import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task01/bloc/transaction_bloc.dart';
import 'package:task01/screens/main_screen.dart';

class TransactionProvider extends StatefulWidget {
  const TransactionProvider({super.key});

  @override
  State<TransactionProvider> createState() => _TransactionProviderState();
}

class _TransactionProviderState extends State<TransactionProvider> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => TransactionBloc(), child: MainScreen(),);
  }
}
