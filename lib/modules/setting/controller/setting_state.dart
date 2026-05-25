import 'package:equatable/equatable.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class PrinterState extends Equatable {
  const PrinterState();

  @override
  List<Object> get props => [];
}

class PrinterNotConnected extends PrinterState {}

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
