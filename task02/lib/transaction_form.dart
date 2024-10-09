import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';


class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Nhập giao dịch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),),
        actions: [

          ElevatedButton(

            onPressed: () {
              if (_formKey.currentState!.saveAndValidate()) {
                print(_formKey.currentState!.value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cập nhật thành công'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Vui lòng điền đủ thông tin'),
                  ),
                );
              }
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              shadowColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.onSurface),
            ),
            child: const Text('Cập nhật', style: TextStyle(color: Colors.white),),
          ),
          const SizedBox(width: 20,),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01, vertical: MediaQuery.of(context).size.height * 0.02),
                  child: FormBuilderDateTimePicker(
                    name: 'date',
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                    format: DateFormat('dd/MM/yyyy HH:mm:ss'),
                    inputType: InputType.both,
                    decoration: InputDecoration(
                      labelText: 'Thời gian',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_month)
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01, vertical: MediaQuery.of(context).size.height * 0.02),
                  child: FormBuilderTextField(
                    name: 'quantity',
                    decoration: InputDecoration(
                      labelText: 'Số lượng',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01, vertical: MediaQuery.of(context).size.height * 0.02),
                  child: FormBuilderDropdown(
                    name: 'station',
                    decoration: const InputDecoration(
                      labelText: 'Trụ',
                      border: OutlineInputBorder(),
                      hintText: 'Chọn trụ',
                    ),
                    // allowClear: true,
            
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    items: [
                      'Trụ 1',
                      'Trụ 2',
                      'Trụ 3',
                    ].map((tru) => DropdownMenuItem(
                      value: tru,
                      child: Text(tru),
                    )).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01, vertical: MediaQuery.of(context).size.height * 0.02),
                  child: FormBuilderTextField(
                    name: 'revenue',
                    decoration: InputDecoration(
                      labelText: 'Doanh thu',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01, vertical: MediaQuery.of(context).size.height * 0.02),
                  child: FormBuilderTextField(
                    name: 'price',
                    decoration: InputDecoration(
                      labelText: 'Đơn giá',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
