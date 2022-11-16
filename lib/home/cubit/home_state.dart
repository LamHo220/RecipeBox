part of 'home_cubit.dart';

enum Tabs {
  home,
  favorite,
  add,
  explore,
  profile,
}

class HomeState extends Equatable {
  const HomeState({this.tab = Tabs.home, this.isShow = true, this.userDetails = UserDetails.empty});
  
  final Tabs tab;

  final bool isShow;

  final UserDetails userDetails;

  @override
  List<Object> get props => [tab, isShow, userDetails];

  HomeState copyWith({Tabs? tab,bool? isShow,UserDetails? userDetails}){
    return HomeState(tab: tab??this.tab, isShow: isShow??this.isShow, userDetails: userDetails?? this.userDetails);
  }
}
