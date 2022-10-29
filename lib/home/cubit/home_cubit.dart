import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(Tabs tab) => emit(HomeState(tab: tab));
  void setShow(bool flag) => emit(HomeState(isShow: flag));
}
