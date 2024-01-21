import 'package:challenge/app/app.dart';
import 'package:challenge/bootstrap.dart';
import 'package:graph_repository/helpers/config.dart';

void main() {
  Config.graphUrl = 'http://localhost:5054/graphql';
  Config.socketUrl = 'ws://localhost:5054/graphql';

  bootstrap(() => const App());
}
