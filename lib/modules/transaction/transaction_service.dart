import 'package:tik_at_app/data/network/api.dart';

class TransactionService {
  final Api api = Api();

  Future postTransaction(Object data) async {
    return await api.transaction(data);
  }
}
