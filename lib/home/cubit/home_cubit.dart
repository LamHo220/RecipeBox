import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());

  void setTab(Tabs tab) => emit(HomeInitial(tab: tab));
  void setShow(bool flag) => emit(HomeInitial(show: flag));
}
