import 'package:challenge/app/app.dart';
import 'package:challenge/bootstrap.dart';
import 'package:graph_repository/helpers/config.dart';

void main() {
  Config.graphUrl = 'https://graph.nearay.com/graphql';
  Config.socketUrl = 'wss://graph.nearay.com/graphql';

  bootstrap(() => const App());
}
