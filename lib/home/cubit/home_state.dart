part of 'home_cubit.dart';

enum Tabs {
  home,
  favorite,
  add,
  explore,
  profile,
}

class HomeState extends Equatable {
  const HomeState({this.tab = Tabs.home, this.isShow = true});
  final Tabs tab;
  final bool isShow;

  @override
  List<Object> get props => [tab, isShow];
}
