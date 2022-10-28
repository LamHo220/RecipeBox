part of 'home_cubit.dart';

enum Tabs { home, favorite, explore, profile, add }

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
  Tabs get selectedTab => Tabs.home;
  bool get isShow => true;
}

class HomeInitial extends HomeState {
  const HomeInitial({this.tab = Tabs.home, this.show = true});

  final Tabs tab;
  final bool show;

  // @override
  // Map<Object,Object> get props => {tab, show};
  @override
  Tabs get selectedTab => tab;

  @override
  bool get isShow => show;
}
