import 'package:equatable/equatable.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

class PrinterState extends Equatable {
  const PrinterState();

  @override
  List<Object> get props => [];
}

class PrinterNotSelected extends PrinterState {}

class PrinterConnecting extends PrinterState {
  final BluetoothDevice device;

  const PrinterConnecting({required this.device});

  @override
  List<Object> get props => [device];
}

class PrinterConnected extends PrinterState {
  final BluetoothDevice device;

  const PrinterConnected({required this.device});

  @override
  List<Object> get props => [device];
}
