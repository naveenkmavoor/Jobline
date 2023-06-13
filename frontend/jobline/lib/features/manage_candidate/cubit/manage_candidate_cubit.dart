import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'manage_candidate_state.dart';

class ManageCandidateCubit extends Cubit<ManageCandidateState> {
  ManageCandidateCubit() : super(ManageCandidateInitial());
}
