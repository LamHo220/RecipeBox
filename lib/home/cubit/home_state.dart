part of 'home_cubit.dart';

enum Tabs {
  home,
  favorite,
  add,
  explore,
  profile,
}

class HomeState extends Equatable {
  const HomeState(
      {this.tab = Tabs.home,
      this.flag = true,
      this.userDetails = UserDetails.empty});

  final Tabs tab;

  final bool flag;

  final UserDetails userDetails;

  @override
  List<Object> get props => [tab, flag, userDetails];

  HomeState copyWith({Tabs? tab, bool? flag, UserDetails? userDetails}) {
    return HomeState(
        tab: tab ?? this.tab,
        flag: flag ?? this.flag,
        userDetails: userDetails ?? this.userDetails);
  }
}
