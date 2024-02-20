import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/local/model_repos/plan_transact/plan_transact_repo.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/presentation/managers/plan_manager.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PlanTimelineTab extends ConsumerStatefulWidget {
  const PlanTimelineTab({super.key});

  @override
  ConsumerState<PlanTimelineTab> createState() => _PlanTimelineTabState();
}

class _PlanTimelineTabState extends ConsumerState<PlanTimelineTab> {

  Color _getColor(Transaction transact) {
    if(transact.paid) {
      return Colors.green;
    }
    final today = DateTime.now().toDateOnly();
    if(today.isAfter(transact.timestamp)) {
      return Colors.red;
    }
    return Colors.amber;
  }

  bool isLate(Transaction transact) {
    final today = DateTime.now().toDateOnly();
    return today.isAfter(transact.timestamp) && transact.paid == false;
  }
  
  @override
  Widget build(BuildContext context) {
    // var planTransacts = context.watch<PlanTransactJsonRepository>().getAll();
    var planTransacts = ref.watch(scheduledPlanTransactProvider(getRangeOfTheMonth())).toList();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SfCalendar(
          showNavigationArrow: true,
          view: CalendarView.month,
          monthViewSettings: const MonthViewSettings(
            showAgenda: true,
            agendaItemHeight: 60.0,
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
          ),
          dataSource: PlanTransactionCalendarData(planTransacts),
          appointmentBuilder: (context, calendarAppointmentDetails) {
            final appointment = calendarAppointmentDetails.appointments.first as Transaction;
            
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _getColor(appointment),
                    // switch(appointment.status) {
                    //   PaidStatus.late => Colors.red,
                    //   PaidStatus.upcoming => Colors.amber,
                    //   PaidStatus.paid => Colors.green,
                    // },
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.planTransactTitle!,
                            style: const TextStyle(
                              fontSize: 12
                            ),
                          ),
                          Text(
                            "${NumberFormat.decimalPattern().format(appointment.amount)} VND",
                            style: const TextStyle(
                              fontSize: 12
                            ),
                          ),
                        ],
                      )
                    ),
                    appointment.paid
                    ? const SizedBox(width: 0.1,)
                    : Expanded(
                      flex: 2,
                      child: Switch(
                        value: ref.watch(planTransactNoti(appointment.planTransactId!)).when(
                          data: (data) => data, 
                          error: (error, _) => throw error, 
                          loading: () => false,
                        ), 
                        onChanged: (switchOn) {
                          // context.read<PlanController>().setNotification(appointment.id, switchOn);
                          ref.read(planTransactionProvider.notifier).setPlanTransactNoti(appointment.planTransactId!, switchOn);
                        }
                      )
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlanTransactionCalendarData extends CalendarDataSource<Transaction> {
  PlanTransactionCalendarData(List<Transaction> transacts) {
    appointments = transacts;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].timestamp;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].timestamp;
  }

  @override
  String getSubject(int index) {
    return "${appointments![index].planTransactTitle}";
  }

  @override
  String? getNotes(int index) {
    return "${NumberFormat.decimalPattern().format(appointments![index].amount)} VND";
  }

  @override
  Color getColor(int index) {
    final transact = appointments![index] as Transaction;
    if(transact.paid) {
      return Colors.green;
    }
    final today = DateTime.now().toDateOnly();
    if(today.isAfter(transact.timestamp)) {
      return Colors.red;
    }
    return Colors.amber;
    // return switch((appointments![index] as Transaction).status) {
    //   PaidStatus.late => Colors.red,
    //   PaidStatus.upcoming => Colors.amber,
    //   PaidStatus.paid => Colors.green,
    // };
  }

  @override
  bool isAllDay(int index) => true;
}