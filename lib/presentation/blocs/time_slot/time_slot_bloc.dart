import 'package:bloc/bloc.dart';
import 'package:clinic_admin/app/contracts/time_slot.dart';
import 'package:clinic_admin/app/core/primitives/inputs/no_params.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../app/requests/time_slot_request.dart';
import '../../../domain/entities/get_all_time_slots_entity.dart';
import '../../../domain/entities/time_slot_entity.dart';

part 'time_slot_state.dart';
part 'time_slot_event.dart';
part 'time_slot_bloc.freezed.dart';

class TimeSlotBloc extends Bloc<TimeSlotEvent, TimeSlotState> {
  final AddTimeSlotQuery addTimeSlot;
  final GetTimeSlotsQuery getTimeSlotsQuery;
  TimeSlotBloc(this.addTimeSlot, this.getTimeSlotsQuery)
      : super(const TimeSlotState.initial()) {
    on<TimeSlotEvent>(
      (event, emit) async {
        await event.maybeMap(
          orElse: () {},
          addTimeSlot: (value) async {
            emit(const TimeSlotState.loading());
            final result = await addTimeSlot.call(value.timeSlot);
            await result.fold(
              (l) async {
                emit(TimeSlotState.failure(message: l.message));
              },
              (r) async {
                if (r.isSuccess == true) {
                  emit(TimeSlotState.success(slots: r.value));
                } else {
                  emit(TimeSlotState.failure(message: r.errors![0]));
                }
              },
            );
          },
          getAllTimeSlots: (value) async {
            emit(const TimeSlotState.loading());
            final result = await getTimeSlotsQuery.call(NoParams());
            await result.fold(
              (l) async {
                emit(TimeSlotState.failure(message: l.message));
              },
              (r) async {
                if (r.isSuccess == true) {
                  emit(TimeSlotState.success(slots: r.value));
                } else {
                  emit(TimeSlotState.failure(message: r.errors![0]));
                }
              },
            );
          },
        );
      },
    );
  }
}