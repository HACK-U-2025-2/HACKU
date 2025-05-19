import 'package:frontend/types/destination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_provider.g.dart';

@Riverpod(keepAlive: true)
class SelectedDestination extends _$SelectedDestination {
  @override
  Destination build() {
    return Destination.home;
  }

  // stateはテストコードのみ参照可能であるため、単純な代入でも関数でラップする
  // ignore: use_setters_to_change_properties
  void setDestination(Destination destination) {
    state = destination;
  }
}
