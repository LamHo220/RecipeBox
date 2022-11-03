part of 'searcher_cubit.dart';

class SearcherState extends Equatable {
  SearcherState();
  final TextEditingController controller = TextEditingController();
  @override
  List<Object> get props => [controller];
}
